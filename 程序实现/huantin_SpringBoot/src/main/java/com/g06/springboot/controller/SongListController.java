package com.g06.springboot.controller;

import com.g06.springboot.entity.SongList;
import com.g06.springboot.service.SongListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 *@Description 负责歌单的逻辑控制
 *@Author ZSY
 *@Date 2020/12/27 22:12
 */
@RestController
@RequestMapping("/songList")
public class SongListController {
	@Autowired
	private SongListService songListService;

	@ResponseBody
	@RequestMapping("/add")
	public void addSongList(@RequestParam int userId,
	                        @RequestParam String songListName,
	                        @RequestParam String songListProfile){
		SongList songList = songListService.checkList(userId, songListName);
		if(songList == null){
			songListService.addList(userId, songListName, songListProfile);
		}

	}

	@ResponseBody
	@RequestMapping("/remove")
	public void removeSongList(@RequestParam int userId,
	                        @RequestParam String songListName){
		SongList songList = songListService.checkList(userId, songListName);
		if(songList != null){
			songListService.removeList(userId, songListName);
		}

	}

	@ResponseBody
	@RequestMapping("/modify")
	public void modifySongList(@RequestParam int userId,
	                           @RequestParam String songListName,
	                           @RequestParam String songListProfile,
	                           @RequestParam String songListAvatar){
		SongList songList = songListService.checkList(userId, songListName);
		if(songList != null){
			songListService.modifyList(userId, songListName, songListProfile, songListAvatar);
		}

	}




}
