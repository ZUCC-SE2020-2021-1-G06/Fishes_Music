/*
Navicat MySQL Data Transfer

Source Server         : aliyun
Source Server Version : 50732
Source Host           : 121.196.105.48:3306
Source Database       : magicmusic

Target Server Type    : MYSQL
Target Server Version : 50732
File Encoding         : 65001

Date: 2021-01-20 11:54:19
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `suggestion` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `useraccount` (`userId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for listSong
-- ----------------------------
DROP TABLE IF EXISTS `listSong`;
CREATE TABLE `listSong` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `songListId` int(11) DEFAULT NULL,
  `songName` varchar(256) DEFAULT NULL,
  `songId` varchar(255) DEFAULT NULL,
  `songArtist` varchar(10) DEFAULT NULL,
  `songAvatar` varchar(255) DEFAULT NULL,
  `platform` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `songListId` (`songName`) USING BTREE,
  KEY `listSong_ibfk_1` (`songListId`),
  CONSTRAINT `listSong_ibfk_1` FOREIGN KEY (`songListId`) REFERENCES `songList` (`songListId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for songList
-- ----------------------------
DROP TABLE IF EXISTS `songList`;
CREATE TABLE `songList` (
  `songListId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`songListId`),
  KEY `userid` (`userId`),
  CONSTRAINT `songList_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `useraccount` (`userId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for useraccount
-- ----------------------------
DROP TABLE IF EXISTS `useraccount`;
CREATE TABLE `useraccount` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(21) DEFAULT NULL,
  `password` varchar(21) DEFAULT NULL,
  `avatar` varchar(2048) DEFAULT 'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1232936719,2061388130&fm=26&gp=0.jpg',
  PRIMARY KEY (`userId`),
  UNIQUE KEY `username` (`username`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
