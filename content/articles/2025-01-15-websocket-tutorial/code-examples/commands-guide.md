# Command Line Guide for WebSocket Chat Tutorial

## Project Setup Commands

### 1. Environment Verification
```bash
# Check Node.js version (should be 20.x or higher)
node --version

# Check npm version  
npm --version
```

### 2. Project Creation
```bash
# Create project directory
mkdir websocket-chat-app
cd websocket-chat-app

# Initialize npm project
npm init -y

# Install dependencies
npm install express socket.io cors dotenv
npm install --save-dev nodemon
```

### 3. Development Commands
```bash
# Start development server
npm run dev

# Test server health
curl http://localhost:3000/health

# Check running processes
lsof -i :3000
```

### 4. Testing Commands
```bash
# Install WebSocket testing tool
npm install -g wscat

# Test WebSocket connection
wscat -c ws://localhost:3000/socket.io/?EIO=4&transport=websocket

# Load testing
ab -n 1000 -c 10 http://localhost:3000/
```

### 5. Debugging Commands
```bash
# Enable debug mode
DEBUG=socket.io:* npm run dev

# Start with Node inspector
node --inspect server.js

# Monitor real-time connections
watch -n 2 "netstat -an | grep :3000"
```

### 6. Production Commands
```bash
# Install production dependencies only
npm ci --only=production

# Start in production mode
NODE_ENV=production npm start

# Process management with PM2
npm install -g pm2
pm2 start server.js --name "chat-app"
```

### 7. Troubleshooting
```bash
# Kill processes on port 3000
lsof -ti:3000 | xargs kill -9

# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json && npm install
```
