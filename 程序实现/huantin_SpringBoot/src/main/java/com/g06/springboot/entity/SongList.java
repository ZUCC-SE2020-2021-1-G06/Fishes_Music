package com.g06.springboot.entity;

import java.util.ArrayList;

/**
 *@Description 歌单实体类
 *@Author ZSY
 *@Date 2020/12/27 21:28
 */
public class SongList {
	private int userId;
	private String songListName;
	private String songListProfile;
	private String songListAvatar;
	private ArrayList<Song> songs;

	public SongList(int userId, String listName) {
		this.userId = userId;
		this.songListName = listName;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getSongListName() {
		return songListName;
	}

	public void setSongListName(String songListName) {
		this.songListName = songListName;
	}

	public String getSongListProfile() {
		return songListProfile;
	}

	public void setSongListProfile(String songListProfile) {
		this.songListProfile = songListProfile;
	}

	public String getSongListAvatar() {
		return songListAvatar;
	}

	public void setSongListAvatar(String songListAvatar) {
		this.songListAvatar = songListAvatar;
	}

	public ArrayList<Song> getSongs() {
		return songs;
	}

	public void setSongs(ArrayList<Song> songs) {
		this.songs = songs;
	}
}
