# Error Handling and Resilience Patterns

## Connection Error Handling

### Client-Side Connection Management

```javascript
// Enhanced client connection handling
class ResilientChatClient {
  constructor() {
    this.socket = io({
      autoConnect: false,
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionDelayMax: 5000,
      reconnectionAttempts: 5,
      timeout: 20000,
      forceNew: true
    });
    
    this.connectionState = 'disconnected';
    this.messageQueue = [];
    this.isReconnecting = false;
    
    this.setupConnectionHandling();
  }
  
  setupConnectionHandling() {
    // Successful connection
    this.socket.on('connect', () => {
      console.log('Connected to server');
      this.connectionState = 'connected';
      this.isReconnecting = false;
      this.updateConnectionUI('connected', 'Connected');
      this.processQueuedMessages();
      this.enableUI();
    });
    
    // Connection lost
    this.socket.on('disconnect', (reason) => {
      console.log('Disconnected:', reason);
      this.connectionState = 'disconnected';
      this.updateConnectionUI('disconnected', 'Disconnected');
      this.disableUI();
      
      // Handle different disconnect reasons
      switch (reason) {
        case 'io server disconnect':
          // Server initiated disconnect - don't reconnect automatically
          this.showMessage('Disconnected by server. Please refresh to reconnect.', 'error');
          this.socket.disconnect();
          break;
        case 'io client disconnect':
          // Client initiated disconnect - normal
          break;
        default:
          // Network issues - will auto-reconnect
          this.showMessage('Connection lost. Attempting to reconnect...', 'warning');
      }
    });
    
    // Connection error
    this.socket.on('connect_error', (error) => {
      console.error('Connection error:', error);
      this.connectionState = 'error';
      this.updateConnectionUI('error', 'Connection Error');
      
      // Provide user feedback based on error type
      if (error.message.includes('xhr poll error')) {
        this.showMessage('Network connectivity issues detected', 'error');
      } else if (error.message.includes('timeout')) {
        this.showMessage('Connection timeout - server may be unavailable', 'error');
      } else {
        this.showMessage('Unable to connect to chat server', 'error');
      }
    });
    
    // Reconnection attempts
    this.socket.on('reconnect_attempt', (attemptNumber) => {
      console.log(`Reconnection attempt ${attemptNumber}`);
      this.isReconnecting = true;
      this.updateConnectionUI('reconnecting', `Reconnecting... (${attemptNumber}/5)`);
    });
    
    // Successful reconnection
    this.socket.on('reconnect', (attemptNumber) => {
      console.log(`Reconnected after ${attemptNumber} attempts`);
      this.connectionState = 'connected';
      this.isReconnecting = false;
      this.showMessage('Reconnected successfully!', 'success');
      
      // Rejoin room if we were in one
      if (this.currentRoom) {
        this.rejoinCurrentRoom();
      }
    });
    
    // Failed to reconnect
    this.socket.on('reconnect_failed', () => {
      console.log('Failed to reconnect');
      this.connectionState = 'failed';
      this.isReconnecting = false;
      this.updateConnectionUI('failed', 'Connection Failed');
      this.showMessage('Unable to reconnect. Please refresh the page.', 'error');
      this.showReconnectButton();
    });
    
    // Reconnection error
    this.socket.on('reconnect_error', (error) => {
      console.error('Reconnection error:', error);
    });
  }
  
  // Manual reconnection
  manualReconnect() {
    if (this.socket.disconnected) {
      this.showMessage('Attempting to reconnect...', 'info');
      this.socket.connect();
    }
  }
  
  // Process messages that were queued during disconnection
  processQueuedMessages() {
    if (this.messageQueue.length > 0) {
      console.log(`Processing ${this.messageQueue.length} queued messages`);
      
      this.messageQueue.forEach(message => {
        this.sendMessage(message.text, message.callback);
      });
      
      this.messageQueue = [];
      this.showMessage(`Sent ${this.messageQueue.length} queued messages`, 'success');
    }
  }
  
  // Enhanced message sending with queuing
  sendMessage(messageText, callback = null) {
    if (!messageText.trim()) return;
    
    const messageData = {
      text: messageText.trim(),
      timestamp: new Date().toISOString()
    };
    
    // If disconnected, queue the message
    if (this.connectionState !== 'connected') {
      this.messageQueue.push({ 
        text: messageText,
        callback: callback,
        queuedAt: new Date().toISOString()
      });
      
      this.showMessage('Message queued - will send when reconnected', 'warning');
      return;
    }
    
    // Send with timeout and retry logic
    const timeout = setTimeout(() => {
      this.showMessage('Message send timeout - message queued for retry', 'warning');
      this.messageQueue.push({ text: messageText, callback: callback });
    }, 5000);
    
    this.socket.emit('chat-message', messageData, (response) => {
      clearTimeout(timeout);
      
      if (response && response.success) {
        if (callback) callback(null, response);
      } else {
        const error = response ? response.error : 'Unknown error';
        this.showMessage(`Failed to send message: ${error}`, 'error');
        
        // Queue for retry if it's a temporary error
        if (this.isRetryableError(error)) {
          this.messageQueue.push({ text: messageText, callback: callback });
        }
        
        if (callback) callback(error);
      }
    });
  }
  
  // Determine if an error is worth retrying
  isRetryableError(error) {
    const retryableErrors = [
      'network error',
      'timeout',
      'server busy',
      'temporary error'
    ];
    
    return retryableErrors.some(retryable => 
      error.toLowerCase().includes(retryable)
    );
  }
}
```

### Server-Side Error Handling

```javascript
// Enhanced server error handling
class ChatServer {
  constructor() {
    this.setupErrorHandling();
    this.setupGracefulShutdown();
    this.connectionLimits = new Map(); // Track connections per IP
  }
  
  setupErrorHandling() {
    // Global error handlers
    process.on('uncaughtException', (error) => {
      console.error('Uncaught Exception:', error);
      this.logError(error, 'uncaught_exception');
      
      // Graceful shutdown for critical errors
      if (this.isCriticalError(error)) {
        this.gracefulShutdown();
      }
    });
    
    process.on('unhandledRejection', (reason, promise) => {
      console.error('Unhandled Rejection at:', promise, 'reason:', reason);
      this.logError(reason, 'unhandled_rejection');
    });
    
    // Socket.IO error handling
    this.io.engine.on('connection_error', (err) => {
      console.error('Connection error:', {
        req: err.req.url,
        code: err.code,
        message: err.message,
        context: err.context
      });
      
      this.logError(err, 'connection_error');
    });
  }
  
  setupSocketErrorHandling(socket) {
    // Individual socket error handling
    socket.on('error', (error) => {
      console.error(`Socket error for ${socket.id}:`, error);
      this.logError(error, 'socket_error', { socketId: socket.id });
      
      // Disconnect problematic sockets
      if (this.isSevereSocketError(error)) {
        socket.disconnect(true);
      }
    });
    
    // Rate limiting
    socket.use((packet, next) => {
      const clientIP = socket.handshake.address;
      
      if (this.isRateLimited(clientIP)) {
        const error = new Error('Rate limit exceeded');
        error.data = { type: 'rate_limit' };
        return next(error);
      }
      
      next();
    });
    
    // Message validation middleware
    socket.use((packet, next) => {
      const [event, data] = packet;
      
      try {
        this.validateEvent(event, data);
        next();
      } catch (error) {
        console.error('Event validation failed:', error);
        next(error);
      }
    });
  }
  
  // Enhanced message handling with error recovery
  handleChatMessage(socket, messageData, callback) {
    try {
      // Validate message
      if (!this.validateMessage(messageData)) {
        return callback({ 
          success: false, 
          error: 'Invalid message format' 
        });
      }
      
      // Check user authentication
      if (!socket.username || !socket.currentRoom) {
        return callback({ 
          success: false, 
          error: 'Not properly authenticated or in a room' 
        });
      }
      
      // Sanitize and process message
      const sanitizedMessage = this.sanitizeMessage(messageData.text);
      
      const message = {
        id: this.generateMessageId(),
        text: sanitizedMessage,
        username: socket.username,
        userId: socket.id,
        room: socket.currentRoom,
        timestamp: new Date().toISOString()
      };
      
      // Store message with retry logic
      this.storeMessage(message)
        .then(() => {
          // Broadcast to room
          this.io.to(socket.currentRoom).emit('new-message', message);
          
          callback({ 
            success: true, 
            messageId: message.id 
          });
        })
        .catch((error) => {
          console.error('Failed to store message:', error);
          
          // Still broadcast if storage fails (degraded mode)
          this.io.to(socket.currentRoom).emit('new-message', message);
          
          callback({ 
            success: true, 
            messageId: message.id,
            warning: 'Message sent but not stored permanently'
          });
        });
        
    } catch (error) {
      console.error('Error handling chat message:', error);
      this.logError(error, 'chat_message_error', { 
        socketId: socket.id,
        messageData: messageData 
      });
      
      callback({ 
        success: false, 
        error: 'Internal server error' 
      });
    }
  }
  
  // Graceful shutdown handling
  setupGracefulShutdown() {
    const shutdown = (signal) => {
      console.log(`Received ${signal}. Starting graceful shutdown...`);
      
      // Stop accepting new connections
      this.server.close(() => {
        console.log('HTTP server closed');
        
        // Close all socket connections
        this.io.close(() => {
          console.log('Socket.IO server closed');
          process.exit(0);
        });
      });
      
      // Force exit after timeout
      setTimeout(() => {
        console.error('Forced shutdown due to timeout');
        process.exit(1);
      }, 10000);
    };
    
    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));
  }
  
  // Error logging utility
  logError(error, type, metadata = {}) {
    const errorLog = {
      timestamp: new Date().toISOString(),
      type: type,
      message: error.message || error,
      stack: error.stack,
      metadata: metadata
    };
    
    // Log to file or external service
    console.error('ERROR LOG:', JSON.stringify(errorLog, null, 2));
    
    // In production, send to error tracking service
    if (process.env.NODE_ENV === 'production') {
      // Example: Sentry, LogRocket, etc.
      // Sentry.captureException(error, { extra: metadata });
    }
  }
  
  // Circuit breaker pattern for external services
  async storeMessage(message, retries = 3) {
    for (let attempt = 1; attempt <= retries; attempt++) {
      try {
        // Simulate database storage
        await this.database.store(message);
        return true;
      } catch (error) {
        console.error(`Storage attempt ${attempt} failed:`, error);
        
        if (attempt === retries) {
          throw new Error(`Failed to store message after ${retries} attempts`);
        }
        
        // Exponential backoff
        await this.delay(Math.pow(2, attempt) * 1000);
      }
    }
  }
  
  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

## User Interface Error Handling

### Error Display Components

```javascript
// UI error handling utilities
class ErrorManager {
  constructor() {
    this.createErrorContainer();
  }
  
  createErrorContainer() {
    const container = document.createElement('div');
    container.id = 'error-container';
    container.className = 'error-container';
    document.body.appendChild(container);
  }
  
  showError(message, type = 'error', duration = 5000) {
    const errorElement = document.createElement('div');
    errorElement.className = `error-message error-${type}`;
    
    errorElement.innerHTML = `
      <div class="error-content">
        <span class="error-icon">${this.getErrorIcon(type)}</span>
        <span class="error-text">${message}</span>
        <button class="error-close" onclick="this.parentElement.parentElement.remove()">×</button>
      </div>
    `;
    
    document.getElementById('error-container').appendChild(errorElement);
    
    // Auto-remove after duration
    if (duration > 0) {
      setTimeout(() => {
        if (errorElement.parentNode) {
          errorElement.remove();
        }
      }, duration);
    }
    
    return errorElement;
  }
  
  getErrorIcon(type) {
    const icons = {
      error: '⚠️',
      warning: '⚡',
      success: '✅',
      info: 'ℹ️'
    };
    return icons[type] || icons.error;
  }
  
  clearErrors() {
    const container = document.getElementById('error-container');
    container.innerHTML = '';
  }
}

// Connection status indicator
class ConnectionIndicator {
  constructor() {
    this.states = {
      connected: { color: '#28a745', text: 'Connected' },
      disconnected: { color: '#dc3545', text: 'Disconnected' },
      reconnecting: { color: '#ffc107', text: 'Reconnecting...' },
      error: { color: '#dc3545', text: 'Connection Error' },
      failed: { color: '#6c757d', text: 'Connection Failed' }
    };
  }
  
  update(state, customText = null) {
    const indicator = document.getElementById('connection-status');
    const config = this.states[state] || this.states.error;
    
    if (indicator) {
      indicator.style.backgroundColor = config.color;
      indicator.textContent = customText || config.text;
      indicator.className = `connection-status ${state}`;
    }
  }
}
```

## Best Practices Summary

### Error Handling Principles

1. **Fail Gracefully**: Application should continue working even when non-critical components fail
2. **User Feedback**: Always inform users about connection status and errors
3. **Automatic Recovery**: Implement reconnection and retry logic where appropriate
4. **Message Queuing**: Queue messages during disconnections for automatic sending on reconnect
5. **Logging**: Comprehensive error logging for debugging and monitoring
6. **Rate Limiting**: Protect against abuse and resource exhaustion
7. **Validation**: Validate all inputs on both client and server sides
8. **Timeout Handling**: Set appropriate timeouts for all network operations

### Common Error Scenarios

1. **Network Interruption**: User loses internet connection temporarily
2. **Server Restart**: Server restarts while users are connected
3. **Rate Limiting**: User sends messages too quickly
4. **Invalid Data**: Malformed or malicious message data
5. **Authentication**: User session expires or becomes invalid
6. **Resource Exhaustion**: Server runs out of memory or connections
7. **Browser Issues**: Tab becomes inactive or browser closes

This comprehensive error handling approach ensures your WebSocket chat application remains stable and user-friendly even when things go wrong.
