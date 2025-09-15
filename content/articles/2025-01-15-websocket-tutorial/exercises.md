# Practice Exercises for WebSocket Chat Tutorial

## Exercise Set 1: Foundation and Basic Concepts

### Exercise 1.1: Protocol Comparison Lab
**Objective**: Understand the fundamental differences between HTTP and WebSocket communication
**Difficulty**: Beginner
**Time**: 15 minutes

**Your Task**:
Create a simple comparison between HTTP polling and WebSocket communication for a "like counter" feature.

**Part A: HTTP Polling Implementation**
```javascript
// Implement this polling function
function pollForLikes() {
  // TODO: Fetch like count every 2 seconds
  // TODO: Update the display
  // TODO: Log network requests in console
}

// Test: Run for 30 seconds and count HTTP requests
```

**Part B: WebSocket Implementation**
```javascript
// Implement real-time like updates
const socket = io();

socket.on('like-update', (data) => {
  // TODO: Update like count immediately
  // TODO: Log WebSocket messages
});

// Test: Compare network usage with Part A
```

**Expected Learning**:
- HTTP generates 15 requests in 30 seconds
- WebSocket maintains 1 connection with instant updates
- WebSocket has much lower bandwidth usage

**Verification**:
1. Open browser Network tab during both tests
2. Compare request counts and data transferred
3. Note latency differences

---

### Exercise 1.2: Connection Lifecycle Management
**Objective**: Master Socket.IO connection events and states
**Difficulty**: Beginner
**Time**: 20 minutes

**Your Task**:
Build a connection status dashboard that shows detailed connection information.

```javascript
class ConnectionMonitor {
  constructor() {
    this.events = [];
    this.setupMonitoring();
  }
  
  setupMonitoring() {
    // TODO: Track these events with timestamps:
    // - connect
    // - disconnect (with reason)
    // - connect_error
    // - reconnect_attempt
    // - reconnect (with attempt count)
    // - reconnect_failed
    
    // TODO: Display events in a timeline
    // TODO: Show current connection state
    // TODO: Calculate uptime percentage
  }
  
  logEvent(type, data) {
    // TODO: Implement event logging
  }
  
  displayStats() {
    // TODO: Show connection statistics
  }
}
```

**Test Scenarios**:
1. Normal connection and disconnect
2. Server restart while connected
3. Network interruption simulation
4. Multiple rapid reconnection attempts

**Success Criteria**:
- All connection events are logged with timestamps
- Connection state is always accurate
- Uptime percentage is calculated correctly

---

## Exercise Set 2: Message Broadcasting and Room Management

### Exercise 2.1: Advanced Broadcasting Patterns
**Objective**: Implement different message broadcasting strategies
**Difficulty**: Intermediate
**Time**: 30 minutes

**Your Task**:
Extend the basic chat to support multiple broadcasting patterns.

**Part A: Broadcast Types Implementation**
```javascript
class MessageBroadcaster {
  constructor(io, socket) {
    this.io = io;
    this.socket = socket;
  }
  
  // TODO: Implement each broadcast type
  
  broadcastToAll(message) {
    // Send to every connected user (including sender)
  }
  
  broadcastToOthers(message) {
    // Send to everyone except sender
  }
  
  broadcastToRoom(roomId, message) {
    // Send to everyone in specific room
  }
  
  broadcastToRoomExceptSender(roomId, message) {
    // Send to room members except sender
  }
  
  sendPrivateMessage(targetUserId, message) {
    // Send to specific user only
  }
  
  sendToAdmins(message) {
    // Send to users with admin role
  }
}
```

**Part B: Message Priority System**
```javascript
// TODO: Implement priority-based message handling
const MessagePriority = {
  URGENT: 1,    // System alerts, moderation
  HIGH: 2,      // Admin announcements
  NORMAL: 3,    // Regular chat messages
  LOW: 4        // Typing indicators, presence
};

function sendMessageWithPriority(message, priority) {
  // TODO: Handle message based on priority
  // TODO: Queue low-priority messages during high traffic
  // TODO: Always send urgent messages immediately
}
```

**Test Scenarios**:
1. Send messages to different audience types
2. Verify message delivery to correct recipients
3. Test priority queuing under load

**Success Criteria**:
- Each broadcast type works correctly
- Messages reach intended recipients only
- Priority system handles traffic appropriately

---

### Exercise 2.2: Dynamic Room Management
**Objective**: Build a sophisticated room system with permissions
**Difficulty**: Intermediate
**Time**: 45 minutes

**Your Task**:
Create a room system that supports different room types and permissions.

```javascript
class RoomManager {
  constructor() {
    this.rooms = new Map();
    this.userRoles = new Map();
  }
  
  createRoom(roomData) {
    // TODO: Implement room creation
    // TODO: Support room types: public, private, announcement-only
    // TODO: Set room capacity limits
    // TODO: Define moderation settings
    
    const room = {
      id: roomData.id,
      name: roomData.name,
      type: roomData.type, // 'public', 'private', 'announcement'
      capacity: roomData.capacity || 100,
      members: new Set(),
      moderators: new Set(),
      settings: {
        allowFiles: true,
        allowImages: true,
        messageHistory: true,
        slowMode: false
      }
    };
    
    // TODO: Store room and notify relevant users
  }
  
  joinRoom(userId, roomId, password = null) {
    // TODO: Validate join permissions
    // TODO: Check room capacity
    // TODO: Verify password for private rooms
    // TODO: Add user to room
    // TODO: Send room history if enabled
  }
  
  leaveRoom(userId, roomId) {
    // TODO: Remove user from room
    // TODO: Handle moderator leaving
    // TODO: Delete room if empty and temporary
  }
  
  setUserRole(roomId, userId, role) {
    // TODO: Implement role system (member, moderator, admin)
    // TODO: Validate permission to assign roles
  }
  
  moderateMessage(roomId, messageId, action, moderatorId) {
    // TODO: Implement message moderation
    // TODO: Actions: delete, edit, flag, timeout
    // TODO: Log moderation actions
  }
}
```

**Advanced Features to Implement**:

1. **Room Discovery System**
```javascript
function discoverRooms(criteria) {
  // TODO: Search rooms by name, topic, member count
  // TODO: Filter by room type and permissions
  // TODO: Sort by activity, creation date, member count
}
```

2. **Room Analytics**
```javascript
function getRoomStats(roomId) {
  // TODO: Track message count, active users, peak times
  // TODO: Generate activity graphs
  // TODO: Identify popular topics
}
```

**Test Scenarios**:
1. Create rooms with different configurations
2. Test permission enforcement
3. Simulate moderation scenarios
4. Verify room discovery works correctly

**Success Criteria**:
- All room types function as specified
- Permission system prevents unauthorized actions
- Moderation tools work effectively
- Room discovery returns relevant results

---

## Exercise Set 3: Advanced Features and Error Handling

### Exercise 3.1: Message Reliability System
**Objective**: Implement guaranteed message delivery with acknowledgments
**Difficulty**: Advanced
**Time**: 40 minutes

**Your Task**:
Build a system that ensures messages are delivered even if connections are unstable.

```javascript
class ReliableMessaging {
  constructor(socket) {
    this.socket = socket;
    this.pendingMessages = new Map();
    this.messageQueue = [];
    this.acknowledgmentTimeout = 5000;
  }
  
  sendReliableMessage(message, priority = 'normal') {
    // TODO: Assign unique message ID
    // TODO: Store message in pending queue
    // TODO: Set acknowledgment timeout
    // TODO: Handle retries with exponential backoff
    
    const messageId = this.generateMessageId();
    const reliableMessage = {
      id: messageId,
      content: message,
      priority: priority,
      timestamp: Date.now(),
      attempts: 0,
      maxAttempts: 3
    };
    
    // TODO: Implement sending logic
    this.attemptSend(reliableMessage);
    
    return messageId;
  }
  
  attemptSend(message) {
    // TODO: Send message with acknowledgment request
    // TODO: Start timeout timer
    // TODO: Handle acknowledgment or retry
  }
  
  handleAcknowledgment(messageId, status) {
    // TODO: Remove from pending if successful
    // TODO: Retry if failed
    // TODO: Move to dead letter queue if max attempts exceeded
  }
  
  processOfflineQueue() {
    // TODO: Send queued messages when connection restored
    // TODO: Respect message priorities
    // TODO: Handle queue size limits
  }
}
```

**Message States to Track**:
- `pending`: Waiting for acknowledgment
- `delivered`: Successfully acknowledged
- `failed`: Max retries exceeded
- `queued`: Waiting for connection

**Test Scenarios**:
1. Normal message delivery with acknowledgments
2. Network interruption during message sending
3. Server restart with pending messages
4. Queue overflow handling

**Success Criteria**:
- All messages eventually deliver or fail definitively
- Acknowledgment system works reliably
- Offline queue processes correctly on reconnection
- Performance remains good under load

---

### Exercise 3.2: Advanced Error Recovery
**Objective**: Build comprehensive error handling for production scenarios
**Difficulty**: Advanced
**Time**: 35 minutes

**Your Task**:
Implement robust error handling that covers real-world failure scenarios.

```javascript
class ErrorRecoverySystem {
  constructor() {
    this.errorCounts = new Map();
    this.recoveryStrategies = new Map();
    this.setupRecoveryStrategies();
  }
  
  setupRecoveryStrategies() {
    // TODO: Define recovery strategies for different error types
    
    this.recoveryStrategies.set('network_error', {
      maxRetries: 5,
      backoffStrategy: 'exponential',
      fallbackAction: 'queue_messages'
    });
    
    this.recoveryStrategies.set('server_error', {
      maxRetries: 3,
      backoffStrategy: 'linear',
      fallbackAction: 'show_error_message'
    });
    
    this.recoveryStrategies.set('auth_error', {
      maxRetries: 1,
      backoffStrategy: 'none',
      fallbackAction: 'redirect_to_login'
    });
    
    // TODO: Add more error types and strategies
  }
  
  handleError(error, context) {
    // TODO: Classify error type
    // TODO: Apply appropriate recovery strategy
    // TODO: Track error frequency
    // TODO: Escalate if patterns detected
    
    const errorType = this.classifyError(error);
    const strategy = this.recoveryStrategies.get(errorType);
    
    if (strategy) {
      this.applyRecoveryStrategy(error, strategy, context);
    } else {
      this.handleUnknownError(error, context);
    }
  }
  
  classifyError(error) {
    // TODO: Analyze error and return classification
    if (error.code === 'NETWORK_ERROR') return 'network_error';
    if (error.status >= 500) return 'server_error';
    if (error.status === 401) return 'auth_error';
    // TODO: Add more classifications
    return 'unknown_error';
  }
  
  applyRecoveryStrategy(error, strategy, context) {
    // TODO: Implement strategy application
    // TODO: Handle retries with appropriate backoff
    // TODO: Execute fallback actions
    // TODO: Log recovery attempts
  }
  
  monitorErrorPatterns() {
    // TODO: Detect error spikes
    // TODO: Identify problematic patterns
    // TODO: Trigger circuit breakers if needed
    // TODO: Generate alerts for administrators
  }
}
```

**Error Scenarios to Handle**:

1. **Network Failures**
```javascript
// TODO: Simulate and handle network interruptions
function simulateNetworkFailure(duration) {
  // Disconnect for specified duration
  // Test automatic reconnection
  // Verify message queuing works
}
```

2. **Server Overload**
```javascript
// TODO: Handle server capacity issues
function handleServerOverload() {
  // Implement backpressure
  // Queue non-essential requests
  // Show user-friendly messages
}
```

3. **Authentication Expiry**
```javascript
// TODO: Handle session expiration
function handleAuthExpiry() {
  // Detect auth failure
  // Attempt token refresh
  // Redirect to login if needed
}
```

**Test Scenarios**:
1. Simulate various error conditions
2. Verify appropriate recovery strategies activate
3. Test error pattern detection
4. Ensure user experience remains smooth

**Success Criteria**:
- Different error types are handled appropriately
- Recovery strategies reduce user-visible failures
- Error patterns are detected and reported
- System degrades gracefully under stress

---

## Exercise Set 4: Performance and Scaling

### Exercise 4.1: Load Testing and Optimization
**Objective**: Test application performance under realistic load
**Difficulty**: Advanced
**Time**: 30 minutes

**Your Task**:
Create a comprehensive load testing suite and identify performance bottlenecks.

```javascript
class LoadTester {
  constructor(serverUrl) {
    this.serverUrl = serverUrl;
    this.clients = [];
    this.metrics = {
      connectionsPerSecond: 0,
      messagesPerSecond: 0,
      averageLatency: 0,
      errorRate: 0
    };
  }
  
  async simulateUsers(userCount, scenarioConfig) {
    // TODO: Create specified number of simulated users
    // TODO: Each user follows realistic behavior patterns
    // TODO: Measure performance metrics
    
    for (let i = 0; i < userCount; i++) {
      const client = new SimulatedUser(this.serverUrl, i);
      await client.connect();
      this.clients.push(client);
      
      // TODO: Stagger connections to avoid thundering herd
      await this.delay(scenarioConfig.connectionDelay);
    }
    
    // TODO: Start user behavior simulation
    this.startBehaviorSimulation(scenarioConfig);
  }
  
  startBehaviorSimulation(config) {
    // TODO: Implement realistic user behaviors:
    // - Join/leave rooms randomly
    // - Send messages at human-like intervals
    // - Go offline/online periodically
    // - Create typing indicators
  }
  
  measurePerformance() {
    // TODO: Track key metrics:
    // - Connection establishment time
    // - Message delivery latency
    // - Memory usage growth
    // - CPU utilization
    // - Error rates
  }
  
  generateReport() {
    // TODO: Create performance report
    // TODO: Identify bottlenecks
    // TODO: Suggest optimizations
  }
}

class SimulatedUser {
  constructor(serverUrl, userId) {
    this.serverUrl = serverUrl;
    this.userId = userId;
    this.behaviors = [
      'active_chatter',    // Sends messages frequently
      'lurker',           // Reads but rarely sends
      'room_hopper',      // Changes rooms often
      'sporadic_user'     // Connects/disconnects randomly
    ];
    this.currentBehavior = this.randomBehavior();
  }
  
  async simulateBehavior() {
    // TODO: Implement behavior-specific actions
    switch (this.currentBehavior) {
      case 'active_chatter':
        await this.sendRandomMessage();
        break;
      case 'lurker':
        await this.readMessages();
        break;
      case 'room_hopper':
        await this.switchRoom();
        break;
      case 'sporadic_user':
        await this.randomDisconnect();
        break;
    }
  }
}
```

**Load Test Scenarios**:
1. **Gradual Ramp-Up**: 1-1000 users over 10 minutes
2. **Spike Test**: Sudden surge to 500 users
3. **Sustained Load**: 200 users for 30 minutes
4. **Stress Test**: Push beyond normal capacity

**Success Criteria**:
- Application handles target load without crashes
- Response times remain acceptable under load
- Memory usage stays within reasonable bounds
- Error rates remain below 1%

---

### Exercise 4.2: Horizontal Scaling Preparation
**Objective**: Prepare application for multi-server deployment
**Difficulty**: Advanced
**Time**: 45 minutes

**Your Task**:
Modify the application to support horizontal scaling with Redis adapter.

```javascript
// TODO: Implement Redis adapter integration
const { createAdapter } = require('@socket.io/redis-adapter');
const { createClient } = require('redis');

class ScalableChat {
  constructor() {
    this.setupRedisAdapter();
    this.setupSessionStore();
    this.setupMessagePersistence();
  }
  
  setupRedisAdapter() {
    // TODO: Configure Redis for Socket.IO scaling
    const pubClient = createClient({ host: 'localhost', port: 6379 });
    const subClient = pubClient.duplicate();
    
    // TODO: Handle Redis connection errors
    // TODO: Implement reconnection logic
    // TODO: Monitor Redis performance
  }
  
  setupSessionStore() {
    // TODO: Store user sessions in Redis
    // TODO: Handle session failover
    // TODO: Implement session cleanup
  }
  
  setupMessagePersistence() {
    // TODO: Store messages in database
    // TODO: Implement message history retrieval
    // TODO: Handle database failover
  }
  
  distributeLoad() {
    // TODO: Implement load balancing strategies
    // TODO: Route users to least loaded servers
    // TODO: Handle server failures gracefully
  }
}
```

**Scaling Considerations**:

1. **Sticky Sessions Configuration**
```javascript
// TODO: Configure load balancer for sticky sessions
// TODO: Handle session migration during server failures
```

2. **Cross-Server Communication**
```javascript
// TODO: Ensure messages broadcast across all servers
// TODO: Synchronize room membership across instances
```

3. **Health Monitoring**
```javascript
// TODO: Implement health checks for load balancer
// TODO: Monitor per-instance metrics
// TODO: Auto-scale based on load
```

**Test Scenarios**:
1. Deploy to multiple server instances
2. Verify cross-server message delivery
3. Test server failure scenarios
4. Validate load distribution

**Success Criteria**:
- Messages deliver across all server instances
- Load distributes evenly across servers
- Application survives individual server failures
- Performance scales linearly with server count

These exercises provide hands-on experience with all aspects of production WebSocket development, from basic concepts to advanced scaling techniques.
