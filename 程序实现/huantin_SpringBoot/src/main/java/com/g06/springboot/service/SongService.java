package com.g06.springboot.service;

import com.g06.springboot.entity.Song;
import com.g06.springboot.mapper.SongMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *@Description SongService 调用 SongMapper 数据库方法
 *@Author ZSY
 *@Date 2020/12/27 23:07
 */
@Service
public class SongService {
	@Autowired
	SongMapper songMapper;
	public Song checkSong(int songListId, String songId, String platform){
		return songMapper.checkSong(songListId, songId, platform);
	}

	public void addSong(int songListId, String songId, String platform){
		songMapper.addSong(songListId, songId, platform);
	}

	public void removeSong(int songListId, String songId){
		songMapper.removeSong(songListId, songId);
	}

}
