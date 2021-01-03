package com.g06.springboot.service;

import com.g06.springboot.entity.SongList;
import com.g06.springboot.mapper.SongListMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *@Description SongListService 调用 SongListMapper 的数据库方法
 *@Author ZSY
 *@Date 2020/12/27 22:03
 */

@Service
public class SongListService {
	@Autowired
	SongListMapper songListMapper;
	public SongList checkList(int userId, String songListName){
		return songListMapper.checkList(userId,songListName);
	}
	public void addList(int userId, String songListName, String songListProfile){
		songListMapper.addList(userId, songListName, songListProfile);
	}
	public void removeList(int userId, String songListName){
		songListMapper.removeList(userId, songListName);
	}
	public void modifyList(int userId, String songListName, String songListProfile, String songListAvatar){
		songListMapper.modifyList(userId, songListName, songListProfile, songListAvatar);
	}
}
