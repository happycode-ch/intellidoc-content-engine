# WebSocket Tutorial Architectural Diagrams

## Diagram 1: WebSocket Protocol Handshake Sequence

### ASCII Art Representation
```
Client                                Server
  |                                     |
  |  HTTP GET /socket.io/?EIO=4        |
  |  Host: example.com                 |
  |  Upgrade: websocket                |
  |  Connection: Upgrade               |
  |  Sec-WebSocket-Key: dGhlIHNhbXB... |
  |------------------------------------>|
  |                                     |
  |  HTTP/1.1 101 Switching Protocols  |
  |  Upgrade: websocket                |
  |  Connection: Upgrade               |
  |  Sec-WebSocket-Accept: s3pPLMBi... |
  |<------------------------------------|
  |                                     |
  |====== WebSocket Connection ========|
  |                                     |
  |  {"type":"connect","namespace":"/"}|
  |------------------------------------>|
  |                                     |
  |  {"type":"connect","data":"sid"}   |
  |<------------------------------------|
  |                                     |
```

### Visual Diagram Elements
**Components:**
- Client browser (laptop icon)
- Server infrastructure (server rack icon)
- HTTP request/response arrows (dashed lines)
- WebSocket connection (solid bidirectional line)
- Protocol headers (text boxes)

**Color Coding:**
- HTTP phase: Orange arrows (#ff9500)
- WebSocket phase: Blue arrows (#007bff)
- Success indicators: Green checkmarks (#28a745)
- Data flow: Purple gradient (#6f42c1 to #007bff)

## Diagram 2: Client-Server Architecture Overview

### System Architecture Layout
```
┌─────────────────────────────────────────────────────────────┐
│                    WebSocket Chat System                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │   Client    │    │   Client    │    │   Client    │     │
│  │  (Browser)  │    │  (Mobile)   │    │  (Desktop)  │     │
│  │             │    │             │    │             │     │
│  │ Socket.IO   │    │ Socket.IO   │    │ Socket.IO   │     │
│  │ Client Lib  │    │ Client Lib  │    │ Client Lib  │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│         │                   │                   │          │
│         │ WebSocket         │ WebSocket         │          │
│         │ Connection        │ Connection        │          │
│         ▼                   ▼                   ▼          │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              Load Balancer (nginx)                     ││
│  └─────────────────────────────────────────────────────────┘│
│                              │                              │
│              ┌───────────────┼───────────────┐             │
│              ▼               ▼               ▼             │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐│
│  │   Server 1      │ │   Server 2      │ │   Server 3      ││
│  │                 │ │                 │ │                 ││
│  │ Node.js         │ │ Node.js         │ │ Node.js         ││
│  │ Express         │ │ Express         │ │ Express         ││
│  │ Socket.IO       │ │ Socket.IO       │ │ Socket.IO       ││
│  └─────────────────┘ └─────────────────┘ └─────────────────┘│
│              │               │               │              │
│              └───────────────┼───────────────┘             │
│                              ▼                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              Redis Adapter                             ││
│  │          (Cross-server messaging)                     ││
│  └─────────────────────────────────────────────────────────┘│
│                              │                              │
│                              ▼                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              Database Layer                            ││
│  │           (User data & message history)               ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

### Component Specifications
**Layer Breakdown:**
1. **Client Layer:** Browser, mobile, desktop applications
2. **Load Balancing:** Traffic distribution and SSL termination
3. **Application Layer:** Node.js servers with Socket.IO
4. **Messaging Layer:** Redis for cross-server communication
5. **Data Layer:** MongoDB/PostgreSQL for persistence

## Diagram 3: Event Flow and Message Broadcasting

### Message Flow Visualization
```
Room: "general"
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│ User A (Client 1)        Server          User B (Client 2) │
│        │                   │                      │        │
│        │ 1. send-message   │                      │        │
│        │ "Hello everyone!" │                      │        │
│        │─────────────────→ │                      │        │
│        │                   │                      │        │
│        │                   │ 2. validate message │        │
│        │                   │    add metadata     │        │
│        │                   │                      │        │
│        │                   │ 3. broadcast to room│        │
│        │                   │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤        │
│        │ 4. new-message    │ ↓                    │        │
│        │ (echo to sender)  │                      │        │
│        │← ─ ─ ─ ─ ─ ─ ─ ─ ─│                      │        │
│        │                   │                      │        │
│        │                   │ 5. new-message      │        │
│        │                   │ (to other users)    │        │
│        │                   │─────────────────────→│        │
│        │                   │                      │        │
│                                                             │
│ User C (Client 3)                       User D (Client 4)  │
│        │                                         │          │
│        │ 6. new-message                         │          │
│        │ (to all room members)                  │          │
│        │← ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│          │
│        │                                         │          │
└─────────────────────────────────────────────────────────────┘

Legend:
─────→  Direct message to server
- - ->  Server processing
←─────  Server response/broadcast
```

### Event Types and Routing
**Client to Server Events:**
- `authenticate`: User login validation
- `join-room`: Room membership management
- `send-message`: Message broadcasting
- `typing-start/stop`: Activity indicators
- `disconnect`: Cleanup operations

**Server to Client Events:**
- `connect-confirmed`: Authentication success
- `room-joined`: Membership confirmation
- `new-message`: Message delivery
- `user-joined/left`: Presence updates
- `error`: Error notifications

## Diagram 4: Room Management and User Organization

### Room Structure Visualization
```
Socket.IO Server Instance
┌─────────────────────────────────────────────────────────────┐
│                     Namespace: "/"                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Room: "general"              Room: "tech-talk"             │
│ ┌─────────────────────┐      ┌─────────────────────┐       │
│ │ Users:              │      │ Users:              │       │
│ │ • alice (socket_1)  │      │ • charlie (socket_3)│       │
│ │ • bob (socket_2)    │      │ • diana (socket_4)  │       │
│ │ • eve (socket_5)    │      │ • frank (socket_6)  │       │
│ │                     │      │                     │       │
│ │ Messages broadcast  │      │ Messages broadcast  │       │
│ │ only to room members│      │ only to room members│       │
│ └─────────────────────┘      └─────────────────────┘       │
│                                                             │
│ Room: "private-chat"         Room: "project-alpha"         │
│ ┌─────────────────────┐      ┌─────────────────────┐       │
│ │ Users:              │      │ Users:              │       │
│ │ • alice (socket_1)  │      │ • bob (socket_2)    │       │
│ │ • charlie (socket_3)│      │ • diana (socket_4)  │       │
│ │                     │      │ • grace (socket_7)  │       │
│ │ Private 1:1 or      │      │                     │       │
│ │ small group chat    │      │ Team collaboration  │       │
│ └─────────────────────┘      └─────────────────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Note: Users can be in multiple rooms simultaneously
Socket connections are managed independently per room
```

### Room Operations Flow
```
User Join Room Sequence:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│ Client              Server             Room State           │
│   │                   │                    │               │
│   │ emit('join-room', │                    │               │
│   │ {roomId: 'tech'}) │                    │               │
│   │─────────────────→ │                    │               │
│   │                   │                    │               │
│   │                   │ 1. Validate room  │               │
│   │                   │ 2. Leave old room │               │
│   │                   │ 3. Join new room  │               │
│   │                   │ ─ ─ ─ ─ ─ ─ ─ ─ ─→│               │
│   │                   │                    │               │
│   │                   │ 4. Update room    │               │
│   │                   │    member list    │               │
│   │                   │← ─ ─ ─ ─ ─ ─ ─ ─ ─│               │
│   │                   │                    │               │
│   │ 5. room-joined    │                    │               │
│   │    confirmation   │                    │               │
│   │←─────────────────│                    │               │
│   │                   │                    │               │
│   │                   │ 6. Notify others  │               │
│   │                   │    'user-joined'  │               │
│   │                   │ ─ ─ ─ ─ ─ ─ ─ ─ ─→│               │
│   │                   │                    │               │
└─────────────────────────────────────────────────────────────┘
```

## Diagram 5: Error Handling and Connection States

### Connection State Machine
```
Connection State Diagram:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│     ┌─────────────┐  connect_error  ┌─────────────┐        │
│  ┌─→│ DISCONNECTED│←────────────────│   ERROR     │←─┐     │
│  │  └─────────────┘                 └─────────────┘  │     │
│  │         │                               │         │     │
│  │         │ socket.connect()              │         │     │
│  │         ▼                               │         │     │
│  │  ┌─────────────┐   timeout/error       │         │     │
│  │  │ CONNECTING  │─────────────────────→ │         │     │
│  │  └─────────────┘                       │         │     │
│  │         │                               │         │     │
│  │         │ connect event                 │         │     │
│  │         ▼                               │         │     │
│  │  ┌─────────────┐                       │         │     │
│  │  │  CONNECTED  │                       │         │     │
│  │  └─────────────┘                       │         │     │
│  │         │                               │         │     │
│  │         │ disconnect event              │         │     │
│  │         ▼                               │         │     │
│  │  ┌─────────────┐  reconnect_failed     │         │     │
│  └──│RECONNECTING │─────────────────────→ │         │     │
│     └─────────────┘                       │         │     │
│            │                               │         │     │
│            │ reconnect event               │         │     │
│            └───────────────────────────────┘         │     │
│                                                      │     │
│                     max_retries_exceeded             │     │
│     ┌─────────────┐ ────────────────────────────────┘     │
│     │   FAILED    │                                       │
│     └─────────────┘                                       │
│                                                           │
└─────────────────────────────────────────────────────────────┘

State Transitions:
• DISCONNECTED → CONNECTING: User initiates connection
• CONNECTING → CONNECTED: Handshake successful
• CONNECTING → ERROR: Connection fails
• CONNECTED → RECONNECTING: Connection lost
• RECONNECTING → CONNECTED: Reconnection successful
• RECONNECTING → FAILED: Max retries exceeded
• ERROR → DISCONNECTED: Error handled
• FAILED → DISCONNECTED: Manual reset
```

### Error Recovery Patterns
```
Error Handling Flow:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│ Error Detection     Error Classification    Recovery Action │
│        │                    │                      │       │
│        ▼                    ▼                      ▼       │
│ ┌─────────────┐   ┌─────────────────┐   ┌─────────────────┐│
│ │Network      │──→│Temporary Issue  │──→│Auto Retry with  ││
│ │Timeout      │   │(Recoverable)    │   │Exponential      ││
│ │             │   │                 │   │Backoff          ││
│ └─────────────┘   └─────────────────┘   └─────────────────┘│
│                                                             │
│ ┌─────────────┐   ┌─────────────────┐   ┌─────────────────┐│
│ │Auth         │──→│User Action      │──→│Redirect to      ││
│ │Failure      │   │Required         │   │Login Page       ││
│ │             │   │                 │   │                 ││
│ └─────────────┘   └─────────────────┘   └─────────────────┘│
│                                                             │
│ ┌─────────────┐   ┌─────────────────┐   ┌─────────────────┐│
│ │Server       │──→│Permanent        │──→│Show Error       ││
│ │Rejection    │   │Failure          │   │Message to User  ││
│ │             │   │                 │   │                 ││
│ └─────────────┘   └─────────────────┘   └─────────────────┘│
│                                                             │
│ ┌─────────────┐   ┌─────────────────┐   ┌─────────────────┐│
│ │Rate Limit   │──→│Temporary        │──→│Queue Messages   ││
│ │Exceeded     │   │Throttling       │   │& Slow Down      ││
│ │             │   │                 │   │                 ││
│ └─────────────┘   └─────────────────┘   └─────────────────┘│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Diagram 6: Scaling and Performance Architecture

### Horizontal Scaling Pattern
```
Multi-Instance Deployment with Load Balancing:

Internet
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                Load Balancer                                │
│          (nginx with sticky sessions)                      │
└─────────────────────────────────────────────────────────────┘
    │
    ├─────────────────┬─────────────────┬─────────────────┐
    ▼                 ▼                 ▼                 ▼
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│Server 1 │    │Server 2 │    │Server 3 │    │Server N │
│         │    │         │    │         │    │         │
│Node.js  │    │Node.js  │    │Node.js  │    │Node.js  │
│Socket.IO│    │Socket.IO│    │Socket.IO│    │Socket.IO│
│Port 3001│    │Port 3002│    │Port 3003│    │Port 300N│
└─────────┘    └─────────┘    └─────────┘    └─────────┘
    │                 │                 │                 │
    └─────────────────┼─────────────────┼─────────────────┘
                      ▼
    ┌─────────────────────────────────────────────────────┐
    │              Redis Cluster                          │
    │                                                     │
    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
    │  │Redis Node 1 │  │Redis Node 2 │  │Redis Node 3 │ │
    │  │   (Master)  │  │  (Replica)  │  │  (Replica)  │ │
    │  └─────────────┘  └─────────────┘  └─────────────┘ │
    └─────────────────────────────────────────────────────┘
                      │
                      ▼
    ┌─────────────────────────────────────────────────────┐
    │              Database Cluster                       │
    │                                                     │
    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
    │  │Primary DB   │  │Secondary DB │  │Secondary DB │ │
    │  │  (Write)    │  │   (Read)    │  │   (Read)    │ │
    │  └─────────────┘  └─────────────┘  └─────────────┘ │
    └─────────────────────────────────────────────────────┘

Scaling Benefits:
• Horizontal scaling of WebSocket connections
• Redis handles cross-server message broadcasting
• Database replication for read scaling
• Load balancer ensures even distribution
• Sticky sessions maintain connection affinity
```

These architectural diagrams provide clear visual representations of WebSocket concepts, system design, and implementation patterns that support the tutorial's learning objectives while demonstrating production-ready architecture principles.
