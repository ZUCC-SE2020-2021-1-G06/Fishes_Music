package com.g06.springboot.entity;
/**
 *@Description 歌曲实体类
 *@Author ZSY
 *@Date 2020/12/27 21:16
 */
public class Song {
	private int id;
	private int songListId;
	private String songId;
	private String platformType;

	public Song(int id, int songListId, String songId, String platformType) {
		this.id = id;
		this.songListId = songListId;
		this.songId = songId;
		this.platformType = platformType;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getSongListId() {
		return songListId;
	}

	public void setSongListId(int songListId) {
		this.songListId = songListId;
	}

	public Song(String songId, String platformType) {
		this.songId = songId;
		this.platformType = platformType;
	}

	public Song(String songId) {
		this.songId = songId;
	}

	public String getSongId() {
		return songId;
	}

	public void setSongId(String songId) {
		this.songId = songId;
	}

	public String getPlatformType() {
		return platformType;
	}

	public void setPlatformType(String platformType) {
		this.platformType = platformType;
	}
}
