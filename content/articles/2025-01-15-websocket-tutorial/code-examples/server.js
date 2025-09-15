// WebSocket Chat Server - Complete Implementation
// Save as: server.js

const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const path = require('path');
require('dotenv').config();

const app = express();
const server = http.createServer(app);

// Initialize Socket.IO with CORS configuration
const io = new Server(server, {
  cors: {
    origin: process.env.NODE_ENV === 'production' 
      ? process.env.ALLOWED_ORIGINS?.split(',') || ['https://yourdomain.com']
      : ['http://localhost:3000'],
    methods: ['GET', 'POST'],
    credentials: true
  },
  // Connection timeout settings
  pingTimeout: 60000,
  pingInterval: 25000
});

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    connections: io.engine.clientsCount
  });
});

// In-memory storage (use database in production)
const chatRooms = new Map();
const connectedUsers = new Map();

// Utility functions
function sanitizeMessage(message) {
  if (typeof message !== 'string') return '';
  return message.trim().substring(0, 500); // Limit message length
}

function getUsersInRoom(roomId) {
  const room = io.sockets.adapter.rooms.get(roomId);
  if (!room) return [];
  
  return Array.from(room).map(socketId => {
    const user = connectedUsers.get(socketId);
    return user ? { id: user.id, username: user.username } : null;
  }).filter(Boolean);
}

function getRoomMessages(roomId, limit = 50) {
  const room = chatRooms.get(roomId);
  if (!room) return [];
  
  return room.messages.slice(-limit);
}

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log(`New connection: ${socket.id}`);
  
  // Handle user identification
  socket.on('user-join', (userData, callback) => {
    try {
      // Validate user data
      if (!userData.username || typeof userData.username !== 'string') {
        callback({ success: false, error: 'Invalid username' });
        return;
      }
      
      const sanitizedUsername = userData.username.trim().substring(0, 30);
      if (sanitizedUsername.length < 2) {
        callback({ success: false, error: 'Username too short' });
        return;
      }
      
      // Store user information
      connectedUsers.set(socket.id, {
        id: socket.id,
        username: sanitizedUsername,
        joinedAt: new Date().toISOString()
      });
      
      socket.username = sanitizedUsername;
      callback({ success: true, userId: socket.id });
      
    } catch (error) {
      console.error('Error in user-join:', error);
      callback({ success: false, error: 'Server error' });
    }
  });
  
  // Handle joining chat rooms
  socket.on('join-room', (roomId, callback) => {
    try {
      if (!socket.username) {
        callback({ success: false, error: 'Must set username first' });
        return;
      }
      
      // Leave current room if any
      const currentRooms = Array.from(socket.rooms).filter(room => room !== socket.id);
      currentRooms.forEach(room => {
        socket.leave(room);
        socket.to(room).emit('user-left', {
          username: socket.username,
          room: room,
          timestamp: new Date().toISOString()
        });
      });
      
      // Join new room
      socket.join(roomId);
      socket.currentRoom = roomId;
      
      // Initialize room if it doesn't exist
      if (!chatRooms.has(roomId)) {
        chatRooms.set(roomId, {
          id: roomId,
          name: roomId,
          messages: [],
          createdAt: new Date().toISOString()
        });
      }
      
      // Notify others in room
      socket.to(roomId).emit('user-joined', {
        username: socket.username,
        room: roomId,
        timestamp: new Date().toISOString()
      });
      
      // Send room data to joining user
      const roomMessages = getRoomMessages(roomId);
      const usersInRoom = getUsersInRoom(roomId);
      
      callback({
        success: true,
        room: {
          id: roomId,
          messages: roomMessages,
          users: usersInRoom
        }
      });
      
      // Update user count for all users in room
      io.to(roomId).emit('room-users-updated', usersInRoom);
      
    } catch (error) {
      console.error('Error in join-room:', error);
      callback({ success: false, error: 'Failed to join room' });
    }
  });
  
  // Handle chat messages
  socket.on('chat-message', (messageData, callback) => {
    try {
      if (!socket.username || !socket.currentRoom) {
        callback({ success: false, error: 'Not properly connected' });
        return;
      }
      
      const sanitizedMessage = sanitizeMessage(messageData.text);
      if (!sanitizedMessage) {
        callback({ success: false, error: 'Invalid message' });
        return;
      }
      
      const message = {
        id: `msg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        text: sanitizedMessage,
        username: socket.username,
        userId: socket.id,
        room: socket.currentRoom,
        timestamp: new Date().toISOString()
      };
      
      // Store message in room
      const room = chatRooms.get(socket.currentRoom);
      if (room) {
        room.messages.push(message);
        // Keep only last 1000 messages per room
        if (room.messages.length > 1000) {
          room.messages = room.messages.slice(-1000);
        }
      }
      
      // Broadcast message to room
      io.to(socket.currentRoom).emit('new-message', message);
      
      callback({ success: true, messageId: message.id });
      
    } catch (error) {
      console.error('Error in chat-message:', error);
      callback({ success: false, error: 'Failed to send message' });
    }
  });
  
  // Handle typing indicators
  socket.on('typing-start', () => {
    if (socket.currentRoom && socket.username) {
      socket.to(socket.currentRoom).emit('user-typing', {
        username: socket.username,
        isTyping: true
      });
    }
  });
  
  socket.on('typing-stop', () => {
    if (socket.currentRoom && socket.username) {
      socket.to(socket.currentRoom).emit('user-typing', {
        username: socket.username,
        isTyping: false
      });
    }
  });
  
  // Handle disconnection
  socket.on('disconnect', (reason) => {
    console.log(`User disconnected: ${socket.id}, reason: ${reason}`);
    
    // Notify room members if user was in a room
    if (socket.currentRoom && socket.username) {
      socket.to(socket.currentRoom).emit('user-left', {
        username: socket.username,
        room: socket.currentRoom,
        timestamp: new Date().toISOString()
      });
      
      // Update user count
      const usersInRoom = getUsersInRoom(socket.currentRoom);
      io.to(socket.currentRoom).emit('room-users-updated', usersInRoom);
    }
    
    // Clean up user data
    connectedUsers.delete(socket.id);
  });
  
  // Handle connection errors
  socket.on('error', (error) => {
    console.error(`Socket error for ${socket.id}:`, error);
  });
});

// Error handling for the server
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  // Graceful shutdown logic here
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
});

// Export for testing
module.exports = { app, server, io };
