// WebSocket Chat Client - Complete Implementation
// Save as: public/client.js

class ChatClient {
  constructor() {
    this.socket = io({
      autoConnect: false,
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionAttempts: 5
    });
    
    this.currentUser = null;
    this.initializeElements();
    this.setupEventListeners();
    this.setupSocketEvents();
  }
  
  initializeElements() {
    this.messagesContainer = document.getElementById("messages");
    this.messageForm = document.getElementById("message-form");
    this.messageInput = document.getElementById("message-input");
    this.sendButton = document.getElementById("send-button");
  }
  
  setupEventListeners() {
    if (this.messageForm) {
      this.messageForm.addEventListener("submit", (e) => {
        e.preventDefault();
        this.sendMessage();
      });
    }
  }
  
  setupSocketEvents() {
    this.socket.on("connect", () => {
      console.log("Connected to server");
    });
    
    this.socket.on("new-message", (message) => {
      this.displayMessage(message);
    });
  }
  
  sendMessage() {
    const messageText = this.messageInput.value.trim();
    if (!messageText) return;
    
    this.socket.emit("chat-message", { text: messageText });
    this.messageInput.value = "";
  }
  
  displayMessage(message) {
    const messageElement = document.createElement("div");
    messageElement.className = "message";
    messageElement.innerHTML = `
      <div class="message-bubble">${message.text}</div>
      <div class="message-info">
        <span>${message.username}</span>
      </div>
    `;
    
    this.messagesContainer.appendChild(messageElement);
    this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  window.chatClient = new ChatClient();
  window.chatClient.socket.connect();
});
