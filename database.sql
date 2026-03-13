-- Script de base de datos para Chat Local
-- Ejecutar en MySQL (XAMPP o servidor local)

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS chatapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chatapp;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    displayName VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatarUrl VARCHAR(255),
    status ENUM('online', 'offline', 'busy') DEFAULT 'offline',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de chats
CREATE TABLE IF NOT EXISTS chats (
    id VARCHAR(36) PRIMARY KEY,
    type ENUM('direct', 'group') NOT NULL,
    title VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_type (type),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de miembros de chat
CREATE TABLE IF NOT EXISTS chat_members (
    chatId VARCHAR(36) NOT NULL,
    userId VARCHAR(36) NOT NULL,
    role ENUM('owner', 'admin', 'member') DEFAULT 'member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chatId, userId),
    FOREIGN KEY (chatId) REFERENCES chats(id) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_userId (userId),
    INDEX idx_chatId (chatId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de mensajes
CREATE TABLE IF NOT EXISTS messages (
    id VARCHAR(36) PRIMARY KEY,
    chatId VARCHAR(36) NOT NULL,
    senderId VARCHAR(36) NOT NULL,
    kind ENUM('text', 'emoji', 'object') DEFAULT 'text',
    content TEXT NOT NULL,
    createdAt BIGINT NOT NULL,
    FOREIGN KEY (chatId) REFERENCES chats(id) ON DELETE CASCADE,
    FOREIGN KEY (senderId) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_chatId_created (chatId, createdAt),
    INDEX idx_senderId (senderId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verificar tablas creadas
SHOW TABLES;
