# WebSocket Chat API Documentation

## Socket.IO Events Reference

### Server-Side Events (Listening)

#### `connection`
**Description**: Fired when a new client connects to the server.
**Parameters**: 
- `socket` (Socket): The connected socket instance

```javascript
io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);
});
```

#### `user-join`
**Description**: Client sets their username and joins the system.
**Parameters**:
- `userData` (Object): User information
  - `username` (string): User's chosen username (2-30 characters)

**Response**: Callback with result object
- `success` (boolean): Whether the operation succeeded
- `userId` (string): Assigned user ID if successful
- `error` (string): Error message if failed

```javascript
socket.on('user-join', (userData, callback) => {
  if (validateUsername(userData.username)) {
    callback({ success: true, userId: socket.id });
  } else {
    callback({ success: false, error: 'Invalid username' });
  }
});
```

#### `join-room`
**Description**: User joins a specific chat room.
**Parameters**:
- `roomId` (string): The room identifier to join

**Response**: Callback with result object
- `success` (boolean): Whether the operation succeeded
- `room` (Object): Room information if successful
  - `id` (string): Room identifier
  - `messages` (Array): Recent messages in the room
  - `users` (Array): Currently connected users
- `error` (string): Error message if failed

```javascript
socket.on('join-room', (roomId, callback) => {
  socket.join(roomId);
  callback({
    success: true,
    room: {
      id: roomId,
      messages: getRoomMessages(roomId),
      users: getUsersInRoom(roomId)
    }
  });
});
```

#### `chat-message`
**Description**: User sends a message to their current room.
**Parameters**:
- `messageData` (Object): Message information
  - `text` (string): The message content (1-500 characters)
  - `timestamp` (string): ISO timestamp of when message was created

**Response**: Callback with result object
- `success` (boolean): Whether the message was sent
- `messageId` (string): Unique message identifier if successful
- `error` (string): Error message if failed

```javascript
socket.on('chat-message', (messageData, callback) => {
  const message = {
    id: generateMessageId(),
    text: sanitize(messageData.text),
    username: socket.username,
    userId: socket.id,
    room: socket.currentRoom,
    timestamp: new Date().toISOString()
  };
  
  io.to(socket.currentRoom).emit('new-message', message);
  callback({ success: true, messageId: message.id });
});
```

#### `typing-start` / `typing-stop`
**Description**: Indicates user is typing or stopped typing.
**Parameters**: None

```javascript
socket.on('typing-start', () => {
  socket.to(socket.currentRoom).emit('user-typing', {
    username: socket.username,
    isTyping: true
  });
});

socket.on('typing-stop', () => {
  socket.to(socket.currentRoom).emit('user-typing', {
    username: socket.username,
    isTyping: false
  });
});
```

#### `disconnect`
**Description**: Fired when a client disconnects.
**Parameters**:
- `reason` (string): Reason for disconnection
  - `'transport close'` - Network issues
  - `'client disconnect'` - Intentional client disconnect
  - `'server disconnect'` - Server initiated disconnect

```javascript
socket.on('disconnect', (reason) => {
  console.log(`User ${socket.id} disconnected: ${reason}`);
  cleanupUserData(socket.id);
});
```

---

### Server-Side Events (Emitting)

#### `new-message`
**Description**: Broadcasts a new message to all users in a room.
**Emitted to**: All users in the message's room
**Data**:
```javascript
{
  id: "msg_1234567890_abc123",        // Unique message ID
  text: "Hello everyone!",             // Message content
  username: "john_doe",               // Sender's username
  userId: "socket_id_123",            // Sender's socket ID
  room: "general",                    // Room where message was sent
  timestamp: "2025-01-15T10:30:00Z"   // ISO timestamp
}
```

#### `user-joined`
**Description**: Notifies room members when a user joins.
**Emitted to**: All users in the room except the joining user
**Data**:
```javascript
{
  username: "jane_smith",             // Username of joining user
  room: "general",                    // Room they joined
  timestamp: "2025-01-15T10:30:00Z"   // When they joined
}
```

#### `user-left`
**Description**: Notifies room members when a user leaves.
**Emitted to**: All users in the room
**Data**:
```javascript
{
  username: "jane_smith",             // Username of leaving user
  room: "general",                    // Room they left
  timestamp: "2025-01-15T10:30:00Z"   // When they left
}
```

#### `room-users-updated`
**Description**: Updates the list of users currently in the room.
**Emitted to**: All users in the room
**Data**: Array of user objects
```javascript
[
  { id: "socket_id_1", username: "alice" },
  { id: "socket_id_2", username: "bob" },
  { id: "socket_id_3", username: "charlie" }
]
```

#### `user-typing`
**Description**: Indicates when a user is typing or stops typing.
**Emitted to**: All users in the room except the typing user
**Data**:
```javascript
{
  username: "alice",                  // Who is typing
  isTyping: true                      // true when starting, false when stopping
}
```

---

### Client-Side Events (Listening)

#### `connect`
**Description**: Client successfully connected to server.
**Parameters**: None

```javascript
socket.on('connect', () => {
  console.log('Connected with ID:', socket.id);
  updateConnectionStatus('connected');
});
```

#### `disconnect`
**Description**: Client disconnected from server.
**Parameters**:
- `reason` (string): Disconnection reason

```javascript
socket.on('disconnect', (reason) => {
  console.log('Disconnected:', reason);
  updateConnectionStatus('disconnected');
});
```

#### `connect_error`
**Description**: Connection attempt failed.
**Parameters**:
- `error` (Error): Error object with details

```javascript
socket.on('connect_error', (error) => {
  console.error('Connection failed:', error.message);
  updateConnectionStatus('error');
});
```

#### `reconnect`
**Description**: Successfully reconnected after disconnect.
**Parameters**:
- `attemptNumber` (number): How many attempts it took

```javascript
socket.on('reconnect', (attemptNumber) => {
  console.log(`Reconnected after ${attemptNumber} attempts`);
  // Rejoin current room if needed
  if (currentRoom) {
    socket.emit('join-room', currentRoom);
  }
});
```

#### Server event handlers (same as server emitting events above)
- `new-message` - New message received
- `user-joined` - User joined current room  
- `user-left` - User left current room
- `room-users-updated` - Room user list changed
- `user-typing` - Someone is typing in room

---

### Client-Side Events (Emitting)

All client events correspond to the server listening events documented above:

- `user-join` - Set username and join system
- `join-room` - Join a specific chat room
- `chat-message` - Send message to current room
- `typing-start` - Indicate user started typing
- `typing-stop` - Indicate user stopped typing

---

## Error Handling

### Common Error Responses

#### Authentication Errors
```javascript
{
  success: false,
  error: "Invalid username"
}
```

#### Rate Limiting Errors
```javascript
{
  success: false,
  error: "Too many messages, please slow down"
}
```

#### Validation Errors
```javascript
{
  success: false,
  error: "Message too long (max 500 characters)"
}
```

#### Server Errors
```javascript
{
  success: false,
  error: "Server error, please try again"
}
```

### Client-Side Error Handling Pattern

```javascript
socket.emit('chat-message', messageData, (response) => {
  if (response.success) {
    // Message sent successfully
    clearMessageInput();
  } else {
    // Handle error
    displayErrorMessage(response.error);
  }
});
```

---

## Rate Limiting

### Message Rate Limits
- **Personal messages**: 10 messages per minute per user
- **Room messages**: 60 messages per minute per room
- **Typing indicators**: 1 update per second per user

### Connection Limits
- **Max connections per IP**: 10 concurrent connections
- **Reconnection attempts**: 5 attempts with exponential backoff
- **Connection timeout**: 20 seconds

---

## Data Validation

### Username Validation
- **Length**: 2-30 characters
- **Characters**: Alphanumeric, spaces, and common symbols (-, _, .)
- **Prohibited**: HTML tags, script content, excessive special characters

### Message Validation
- **Length**: 1-500 characters
- **Content**: HTML escaped for security
- **Prohibited**: Scripts, excessive formatting, spam patterns

### Room ID Validation
- **Length**: 3-50 characters
- **Characters**: Alphanumeric, hyphens, underscores
- **Format**: Must start with letter or number

---

## Development and Debugging

### Enable Debug Mode
```javascript
// Client-side debugging
localStorage.debug = 'socket.io-client:socket';

// Server-side debugging
DEBUG=socket.io:* node server.js
```

### Health Check Endpoint
```
GET /health
Response: {
  "status": "ok",
  "timestamp": "2025-01-15T10:30:00Z",
  "connections": 42
}
```

### Connection Information
```javascript
// Get connection details
console.log('Socket ID:', socket.id);
console.log('Connected:', socket.connected);
console.log('Transport:', socket.io.engine.transport.name);
```

This API documentation provides a complete reference for implementing and extending the WebSocket chat application.
