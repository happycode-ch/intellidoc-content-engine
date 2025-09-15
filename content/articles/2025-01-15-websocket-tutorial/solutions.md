# Exercise Solutions with Detailed Explanations

## Solution Set 1: Foundation and Basic Concepts

### Solution 1.1: Protocol Comparison Lab

**Part A: HTTP Polling Implementation**
```javascript
// HTTP Polling Solution with Analysis
class HTTPPollingDemo {
  constructor() {
    this.likeCount = 0;
    this.requestCount = 0;
    this.startTime = Date.now();
    this.isPolling = false;
  }
  
  async pollForLikes() {
    if (this.isPolling) return;
    this.isPolling = true;
    
    console.log('Starting HTTP polling demo...');
    
    const pollInterval = setInterval(async () => {
      try {
        this.requestCount++;
        const response = await fetch('/api/likes');
        const data = await response.json();
        
        // Update display
        document.getElementById('like-count').textContent = data.likes;
        
        // Log network usage
        console.log(`Request #${this.requestCount}: ${response.headers.get('content-length') || 'unknown'} bytes`);
        
      } catch (error) {
        console.error('Polling error:', error);
      }
    }, 2000);
    
    // Stop after 30 seconds
    setTimeout(() => {
      clearInterval(pollInterval);
      this.analyzeResults('HTTP Polling');
      this.isPolling = false;
    }, 30000);
  }
  
  analyzeResults(method) {
    const duration = (Date.now() - this.startTime) / 1000;
    console.log(`\n${method} Results:`);
    console.log(`Duration: ${duration}s`);
    console.log(`Total requests: ${this.requestCount}`);
    console.log(`Requests per second: ${(this.requestCount / duration).toFixed(2)}`);
    console.log(`Estimated bandwidth: ${this.requestCount * 500} bytes`); // Rough estimate
  }
}
```

**Part B: WebSocket Implementation**
```javascript
// WebSocket Solution with Analysis
class WebSocketDemo {
  constructor() {
    this.likeCount = 0;
    this.messageCount = 0;
    this.startTime = Date.now();
    this.socket = null;
  }
  
  connectWebSocket() {
    console.log('Starting WebSocket demo...');
    
    this.socket = io();
    
    // Track connection
    this.socket.on('connect', () => {
      console.log('WebSocket connected');
      this.startTime = Date.now();
    });
    
    // Handle real-time like updates
    this.socket.on('like-update', (data) => {
      this.messageCount++;
      this.likeCount = data.likes;
      
      // Update display immediately
      document.getElementById('like-count').textContent = this.likeCount;
      
      // Log message (much smaller than HTTP response)
      console.log(`Message #${this.messageCount}: ~${JSON.stringify(data).length} bytes`);
    });
    
    // Analyze after 30 seconds
    setTimeout(() => {
      this.analyzeResults('WebSocket');
      this.socket.disconnect();
    }, 30000);
  }
  
  analyzeResults(method) {
    const duration = (Date.now() - this.startTime) / 1000;
    console.log(`\n${method} Results:`);
    console.log(`Duration: ${duration}s`);
    console.log(`Total messages: ${this.messageCount}`);
    console.log(`Messages per second: ${(this.messageCount / duration).toFixed(2)}`);
    console.log(`Estimated bandwidth: ${this.messageCount * 50} bytes`); // Much smaller
  }
}

// Usage demonstration
const httpDemo = new HTTPPollingDemo();
const wsDemo = new WebSocketDemo();

// Run both demos for comparison
// httpDemo.pollForLikes();
// wsDemo.connectWebSocket();
```

**Key Learning Points**:
1. **Request Count**: HTTP polling generates 15 requests in 30 seconds vs 1 WebSocket connection
2. **Bandwidth**: WebSocket uses ~80% less bandwidth due to smaller message payloads
3. **Latency**: WebSocket updates are instant vs up to 2-second delay with polling
4. **Server Load**: HTTP polling creates constant server load vs event-driven WebSocket load

---

### Solution 1.2: Connection Lifecycle Management

```javascript
// Complete Connection Monitor Solution
class ConnectionMonitor {
  constructor() {
    this.events = [];
    this.connectionStart = null;
    this.totalUptime = 0;
    this.totalDowntime = 0;
    this.socket = io({
      autoConnect: false,
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionAttempts: 5
    });
    
    this.setupMonitoring();
    this.createUI();
  }
  
  setupMonitoring() {
    // Track all connection-related events
    this.socket.on('connect', () => {
      this.connectionStart = Date.now();
      this.logEvent('connect', { 
        socketId: this.socket.id,
        transport: this.socket.io.engine.transport.name 
      });
      this.updateConnectionState('connected');
    });
    
    this.socket.on('disconnect', (reason) => {
      if (this.connectionStart) {
        this.totalUptime += Date.now() - this.connectionStart;
      }
      this.logEvent('disconnect', { reason });
      this.updateConnectionState('disconnected');
    });
    
    this.socket.on('connect_error', (error) => {
      this.logEvent('connect_error', { 
        message: error.message,
        type: error.type 
      });
      this.updateConnectionState('error');
    });
    
    this.socket.on('reconnect_attempt', (attemptNumber) => {
      this.logEvent('reconnect_attempt', { attemptNumber });
      this.updateConnectionState('reconnecting');
    });
    
    this.socket.on('reconnect', (attemptNumber) => {
      this.connectionStart = Date.now();
      this.logEvent('reconnect', { 
        attemptNumber,
        totalAttempts: attemptNumber 
      });
      this.updateConnectionState('connected');
    });
    
    this.socket.on('reconnect_failed', () => {
      this.logEvent('reconnect_failed', {});
      this.updateConnectionState('failed');
    });
  }
  
  logEvent(type, data) {
    const event = {
      type,
      timestamp: new Date().toISOString(),
      data,
      id: `event_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`
    };
    
    this.events.push(event);
    this.updateEventTimeline();
    this.updateStats();
    
    // Log to console with formatting
    console.log(`🔌 ${type.toUpperCase()}:`, data, `at ${event.timestamp}`);
  }
  
  updateConnectionState(state) {
    const indicator = document.getElementById('connection-indicator');
    const stateText = document.getElementById('connection-state');
    
    if (indicator && stateText) {
      indicator.className = `connection-indicator ${state}`;
      stateText.textContent = this.getStateDisplayText(state);
    }
  }
  
  getStateDisplayText(state) {
    const stateMap = {
      connected: '✅ Connected',
      disconnected: '❌ Disconnected',
      reconnecting: '🔄 Reconnecting...',
      error: '⚠️ Connection Error',
      failed: '💀 Connection Failed'
    };
    return stateMap[state] || state;
  }
  
  updateEventTimeline() {
    const timeline = document.getElementById('event-timeline');
    if (!timeline) return;
    
    // Show last 10 events
    const recentEvents = this.events.slice(-10);
    
    timeline.innerHTML = recentEvents.map(event => `
      <div class="timeline-event ${event.type}">
        <div class="event-time">${new Date(event.timestamp).toLocaleTimeString()}</div>
        <div class="event-type">${event.type}</div>
        <div class="event-data">${JSON.stringify(event.data)}</div>
      </div>
    `).join('');
  }
  
  updateStats() {
    const statsContainer = document.getElementById('connection-stats');
    if (!statsContainer) return;
    
    const totalTime = this.totalUptime + this.totalDowntime;
    const uptimePercentage = totalTime > 0 ? (this.totalUptime / totalTime * 100).toFixed(2) : 0;
    
    const stats = {
      totalEvents: this.events.length,
      connectAttempts: this.events.filter(e => e.type === 'connect').length,
      disconnections: this.events.filter(e => e.type === 'disconnect').length,
      errors: this.events.filter(e => e.type === 'connect_error').length,
      uptimePercentage,
      currentState: this.socket.connected ? 'Connected' : 'Disconnected'
    };
    
    statsContainer.innerHTML = `
      <div class="stat-item">
        <label>Current State:</label>
        <span class="${this.socket.connected ? 'connected' : 'disconnected'}">${stats.currentState}</span>
      </div>
      <div class="stat-item">
        <label>Total Events:</label>
        <span>${stats.totalEvents}</span>
      </div>
      <div class="stat-item">
        <label>Connections:</label>
        <span>${stats.connectAttempts}</span>
      </div>
      <div class="stat-item">
        <label>Disconnections:</label>
        <span>${stats.disconnections}</span>
      </div>
      <div class="stat-item">
        <label>Errors:</label>
        <span>${stats.errors}</span>
      </div>
      <div class="stat-item">
        <label>Uptime:</label>
        <span>${stats.uptimePercentage}%</span>
      </div>
    `;
  }
  
  createUI() {
    // Create monitoring dashboard UI
    const monitoringHTML = `
      <div id="connection-monitor">
        <h3>Connection Monitor</h3>
        
        <div id="connection-status">
          <div id="connection-indicator" class="connection-indicator disconnected"></div>
          <span id="connection-state">Disconnected</span>
        </div>
        
        <div id="connection-stats"></div>
        
        <div id="event-timeline-container">
          <h4>Recent Events</h4>
          <div id="event-timeline"></div>
        </div>
        
        <div class="monitor-controls">
          <button onclick="monitor.connect()">Connect</button>
          <button onclick="monitor.disconnect()">Disconnect</button>
          <button onclick="monitor.simulateError()">Simulate Error</button>
          <button onclick="monitor.clearEvents()">Clear Events</button>
        </div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', monitoringHTML);
  }
  
  // Control methods for testing
  connect() {
    if (!this.socket.connected) {
      this.socket.connect();
    }
  }
  
  disconnect() {
    if (this.socket.connected) {
      this.socket.disconnect();
    }
  }
  
  simulateError() {
    // Force a connection error for testing
    this.socket.disconnect();
    setTimeout(() => this.socket.connect(), 1000);
  }
  
  clearEvents() {
    this.events = [];
    this.updateEventTimeline();
    this.updateStats();
  }
}

// Initialize the monitor
const monitor = new ConnectionMonitor();

// CSS for styling (add to your stylesheet)
const monitoringCSS = `
#connection-monitor {
  border: 1px solid #ddd;
  padding: 20px;
  margin: 20px;
  border-radius: 8px;
  background: #f9f9f9;
}

.connection-indicator {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 8px;
}

.connection-indicator.connected { background: #28a745; }
.connection-indicator.disconnected { background: #dc3545; }
.connection-indicator.reconnecting { background: #ffc107; animation: pulse 1s infinite; }
.connection-indicator.error { background: #fd7e14; }
.connection-indicator.failed { background: #6c757d; }

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.timeline-event {
  padding: 8px;
  margin: 4px 0;
  border-left: 4px solid #ddd;
  background: white;
  border-radius: 4px;
}

.timeline-event.connect { border-left-color: #28a745; }
.timeline-event.disconnect { border-left-color: #dc3545; }
.timeline-event.connect_error { border-left-color: #fd7e14; }
.timeline-event.reconnect { border-left-color: #17a2b8; }

.stat-item {
  display: flex;
  justify-content: space-between;
  padding: 4px 0;
  border-bottom: 1px solid #eee;
}

.monitor-controls button {
  margin: 4px;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  background: #007bff;
  color: white;
  cursor: pointer;
}
`;

// Add CSS to page
const style = document.createElement('style');
style.textContent = monitoringCSS;
document.head.appendChild(style);
```

**Key Learning Points**:
1. **Event Tracking**: All connection events are captured with detailed metadata
2. **State Management**: Connection state is always accurately reflected in UI
3. **Performance Monitoring**: Uptime calculation provides reliability metrics
4. **User Feedback**: Visual indicators help users understand connection status
5. **Debugging Support**: Event timeline helps developers identify connection issues

**Testing Scenarios Explained**:
1. **Normal Connect/Disconnect**: Tests basic event handling
2. **Server Restart**: Verifies reconnection logic works correctly
3. **Network Simulation**: Tests resilience to network issues
4. **Rapid Reconnections**: Ensures system handles connection flooding

This solution provides a production-ready connection monitoring system that could be integrated into any WebSocket application for reliability monitoring and debugging.

---

## Solution Set 2: Message Broadcasting and Room Management

### Solution 2.1: Advanced Broadcasting Patterns

```javascript
// Complete Broadcasting System Solution
class MessageBroadcaster {
  constructor(io, socket) {
    this.io = io;
    this.socket = socket;
    this.messageQueue = new Map(); // Priority-based queuing
    this.rateLimits = new Map();   // Rate limiting per user
    this.setupRateLimiting();
  }
  
  // Send to every connected user (including sender)
  broadcastToAll(message) {
    console.log(`Broadcasting to all users: ${message.text}`);
    
    const broadcastMessage = {
      ...message,
      type: 'broadcast_all',
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // io.emit sends to ALL connected sockets
    this.io.emit('message', broadcastMessage);
    
    this.logBroadcast('all', broadcastMessage, this.io.engine.clientsCount);
  }
  
  // Send to everyone except sender
  broadcastToOthers(message) {
    console.log(`Broadcasting to others: ${message.text}`);
    
    const broadcastMessage = {
      ...message,
      type: 'broadcast_others',
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // socket.broadcast.emit sends to all EXCEPT the sender
    this.socket.broadcast.emit('message', broadcastMessage);
    
    this.logBroadcast('others', broadcastMessage, this.io.engine.clientsCount - 1);
  }
  
  // Send to everyone in specific room
  broadcastToRoom(roomId, message) {
    console.log(`Broadcasting to room ${roomId}: ${message.text}`);
    
    const roomMessage = {
      ...message,
      type: 'room_broadcast',
      room: roomId,
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // Get room member count for logging
    const room = this.io.sockets.adapter.rooms.get(roomId);
    const memberCount = room ? room.size : 0;
    
    // io.to(room).emit sends to all sockets in the room
    this.io.to(roomId).emit('message', roomMessage);
    
    this.logBroadcast(`room:${roomId}`, roomMessage, memberCount);
  }
  
  // Send to room members except sender
  broadcastToRoomExceptSender(roomId, message) {
    console.log(`Broadcasting to room ${roomId} (except sender): ${message.text}`);
    
    const roomMessage = {
      ...message,
      type: 'room_broadcast_others',
      room: roomId,
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // socket.to(room).emit sends to room members except sender
    this.socket.to(roomId).emit('message', roomMessage);
    
    const room = this.io.sockets.adapter.rooms.get(roomId);
    const memberCount = room ? room.size - 1 : 0; // Exclude sender
    
    this.logBroadcast(`room:${roomId}:others`, roomMessage, memberCount);
  }
  
  // Send to specific user only
  sendPrivateMessage(targetUserId, message) {
    console.log(`Sending private message to ${targetUserId}: ${message.text}`);
    
    const privateMessage = {
      ...message,
      type: 'private_message',
      recipient: targetUserId,
      sender: this.socket.id,
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // Find target socket and send directly
    const targetSocket = this.io.sockets.sockets.get(targetUserId);
    
    if (targetSocket) {
      targetSocket.emit('private_message', privateMessage);
      
      // Also send confirmation to sender
      this.socket.emit('private_message_sent', {
        messageId: privateMessage.id,
        recipient: targetUserId,
        success: true
      });
      
      this.logBroadcast(`private:${targetUserId}`, privateMessage, 1);
    } else {
      // Target user not found
      this.socket.emit('private_message_error', {
        error: 'User not found or offline',
        targetUserId: targetUserId
      });
      
      console.log(`Private message failed - user ${targetUserId} not found`);
    }
  }
  
  // Send to users with admin role
  sendToAdmins(message) {
    console.log(`Sending admin message: ${message.text}`);
    
    const adminMessage = {
      ...message,
      type: 'admin_message',
      priority: 'high',
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    let adminCount = 0;
    
    // Find all admin users and send message
    this.io.sockets.sockets.forEach((socket) => {
      if (socket.userData && socket.userData.role === 'admin') {
        socket.emit('admin_message', adminMessage);
        adminCount++;
      }
    });
    
    this.logBroadcast('admins', adminMessage, adminCount);
  }
  
  // Priority-based message handling
  sendMessageWithPriority(message, priority = MessagePriority.NORMAL) {
    const priorityMessage = {
      ...message,
      priority: priority,
      timestamp: new Date().toISOString(),
      id: this.generateMessageId()
    };
    
    // Handle based on priority
    switch (priority) {
      case MessagePriority.URGENT:
        // Send immediately, bypass all queues
        this.sendImmediately(priorityMessage);
        break;
        
      case MessagePriority.HIGH:
        // Send soon, minimal queuing
        this.addToHighPriorityQueue(priorityMessage);
        break;
        
      case MessagePriority.NORMAL:
        // Normal processing
        this.addToNormalQueue(priorityMessage);
        break;
        
      case MessagePriority.LOW:
        // Queue for later, can be delayed
        this.addToLowPriorityQueue(priorityMessage);
        break;
    }
  }
  
  sendImmediately(message) {
    // Bypass all queues and rate limits for urgent messages
    console.log(`🚨 URGENT MESSAGE: ${message.text}`);
    this.broadcastToAll(message);
  }
  
  addToHighPriorityQueue(message) {
    if (!this.messageQueue.has('high')) {
      this.messageQueue.set('high', []);
    }
    this.messageQueue.get('high').push(message);
    this.processHighPriorityQueue();
  }
  
  addToNormalQueue(message) {
    // Check rate limits before adding to queue
    if (this.isRateLimited(this.socket.id)) {
      this.socket.emit('rate_limited', {
        message: 'Sending messages too quickly, please slow down',
        retryAfter: this.getRateLimitResetTime(this.socket.id)
      });
      return;
    }
    
    if (!this.messageQueue.has('normal')) {
      this.messageQueue.set('normal', []);
    }
    this.messageQueue.get('normal').push(message);
    this.processNormalQueue();
  }
  
  addToLowPriorityQueue(message) {
    // Low priority messages can be dropped under high load
    const queueSize = this.messageQueue.get('low')?.length || 0;
    
    if (queueSize > 100) {
      console.log('Dropping low priority message due to queue overflow');
      return;
    }
    
    if (!this.messageQueue.has('low')) {
      this.messageQueue.set('low', []);
    }
    this.messageQueue.get('low').push(message);
    
    // Process low priority queue less frequently
    setTimeout(() => this.processLowPriorityQueue(), 1000);
  }
  
  setupRateLimiting() {
    // Rate limiting: 10 messages per minute per user
    this.rateLimitWindow = 60000; // 1 minute
    this.rateLimitMax = 10;
  }
  
  isRateLimited(userId) {
    const now = Date.now();
    const userLimits = this.rateLimits.get(userId) || [];
    
    // Remove old entries outside the window
    const recentMessages = userLimits.filter(timestamp => 
      now - timestamp < this.rateLimitWindow
    );
    
    this.rateLimits.set(userId, recentMessages);
    
    if (recentMessages.length >= this.rateLimitMax) {
      return true;
    }
    
    // Add current message timestamp
    recentMessages.push(now);
    this.rateLimits.set(userId, recentMessages);
    
    return false;
  }
  
  getRateLimitResetTime(userId) {
    const userLimits = this.rateLimits.get(userId) || [];
    if (userLimits.length === 0) return 0;
    
    const oldestMessage = Math.min(...userLimits);
    return this.rateLimitWindow - (Date.now() - oldestMessage);
  }
  
  // Utility methods
  generateMessageId() {
    return `msg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
  
  logBroadcast(type, message, recipientCount) {
    console.log(`📡 Broadcast [${type}]: "${message.text}" to ${recipientCount} recipients`);
    
    // In production, send to monitoring service
    if (process.env.NODE_ENV === 'production') {
      this.sendToMonitoring({
        type: 'message_broadcast',
        broadcastType: type,
        messageId: message.id,
        recipientCount: recipientCount,
        timestamp: message.timestamp
      });
    }
  }
  
  sendToMonitoring(data) {
    // Placeholder for monitoring service integration
    // Example: send to DataDog, New Relic, custom analytics
  }
}

// Priority constants
const MessagePriority = {
  URGENT: 1,    // System alerts, security issues
  HIGH: 2,      // Admin announcements, important notifications
  NORMAL: 3,    // Regular chat messages
  LOW: 4        // Typing indicators, presence updates
};

// Usage example with comprehensive testing
class BroadcastingDemo {
  constructor() {
    this.broadcaster = new MessageBroadcaster(io, socket);
    this.setupTestInterface();
  }
  
  setupTestInterface() {
    // Create test interface for trying different broadcast types
    const testHTML = `
      <div id="broadcast-tester">
        <h3>Message Broadcasting Tester</h3>
        
        <input type="text" id="test-message" placeholder="Enter test message...">
        
        <div class="broadcast-buttons">
          <button onclick="demo.testBroadcastAll()">Broadcast to All</button>
          <button onclick="demo.testBroadcastOthers()">Broadcast to Others</button>
          <button onclick="demo.testRoomBroadcast()">Broadcast to Room</button>
          <button onclick="demo.testPrivateMessage()">Send Private Message</button>
          <button onclick="demo.testAdminMessage()">Send to Admins</button>
        </div>
        
        <div class="priority-buttons">
          <h4>Priority Testing</h4>
          <button onclick="demo.testUrgentMessage()">🚨 Urgent</button>
          <button onclick="demo.testHighPriority()">⚡ High Priority</button>
          <button onclick="demo.testNormalPriority()">📝 Normal</button>
          <button onclick="demo.testLowPriority()">💤 Low Priority</button>
        </div>
        
        <div id="broadcast-log"></div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', testHTML);
  }
  
  getTestMessage() {
    const input = document.getElementById('test-message');
    return input.value || 'Test message';
  }
  
  testBroadcastAll() {
    this.broadcaster.broadcastToAll({ text: this.getTestMessage() });
  }
  
  testBroadcastOthers() {
    this.broadcaster.broadcastToOthers({ text: this.getTestMessage() });
  }
  
  testRoomBroadcast() {
    this.broadcaster.broadcastToRoom('general', { text: this.getTestMessage() });
  }
  
  testPrivateMessage() {
    // In real implementation, get target user ID from UI
    const targetUserId = prompt('Enter target user ID:');
    if (targetUserId) {
      this.broadcaster.sendPrivateMessage(targetUserId, { text: this.getTestMessage() });
    }
  }
  
  testAdminMessage() {
    this.broadcaster.sendToAdmins({ text: this.getTestMessage() });
  }
  
  testUrgentMessage() {
    this.broadcaster.sendMessageWithPriority(
      { text: '🚨 URGENT: ' + this.getTestMessage() }, 
      MessagePriority.URGENT
    );
  }
  
  testHighPriority() {
    this.broadcaster.sendMessageWithPriority(
      { text: '⚡ HIGH: ' + this.getTestMessage() }, 
      MessagePriority.HIGH
    );
  }
  
  testNormalPriority() {
    this.broadcaster.sendMessageWithPriority(
      { text: '📝 ' + this.getTestMessage() }, 
      MessagePriority.NORMAL
    );
  }
  
  testLowPriority() {
    this.broadcaster.sendMessageWithPriority(
      { text: '💤 ' + this.getTestMessage() }, 
      MessagePriority.LOW
    );
  }
}

// Initialize demo
const demo = new BroadcastingDemo();
```

**Key Learning Points from Broadcasting Solution**:

1. **Broadcast Scope Understanding**: 
   - `io.emit()` = everyone including sender
   - `socket.broadcast.emit()` = everyone except sender
   - `io.to(room).emit()` = everyone in room
   - `socket.to(room).emit()` = room members except sender

2. **Priority System Benefits**:
   - Urgent messages bypass all queues and rate limits
   - System messages maintain functionality under load
   - User experience remains smooth during high traffic

3. **Rate Limiting Implementation**:
   - Prevents message spam and abuse
   - Sliding window approach is memory efficient
   - Provides clear feedback to users about limits

4. **Error Handling**:
   - Private messages handle offline users gracefully
   - Queue overflow protection prevents memory issues
   - Monitoring integration enables production debugging

This solution provides a production-ready broadcasting system that scales well and handles edge cases appropriately.

---

*[Continue with remaining solutions...]*

These detailed solutions provide not just working code, but explanations of design decisions, trade-offs, and production considerations that help students understand the reasoning behind each implementation choice.
