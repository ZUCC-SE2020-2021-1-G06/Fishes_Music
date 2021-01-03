package com.g06.springboot.controller;

import com.g06.springboot.entity.Song;
import com.g06.springboot.entity.SongList;
import com.g06.springboot.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 *@Description 负责歌单里歌曲的逻辑控制
 *@Author ZSY
 *@Date 2020/12/27 23:17
 */
@RestController
@RequestMapping("/song")
public class SongController {
	@Autowired
	private SongService songService;

	@ResponseBody
	@RequestMapping("/add")
	public void addSong(@RequestParam int songListId,
	                    @RequestParam String songId,
						@RequestParam String platform){
		Song song = songService.checkSong(songListId, songId, platform);
		if(song == null){
			songService.addSong(songListId, songId, platform);
		}
	}

	@ResponseBody
	@RequestMapping("/remove")
	public void removeSong(@RequestParam int songListId,
	                    @RequestParam String songId,
	                    @RequestParam String platform){
		Song song = songService.checkSong(songListId, songId, platform);
		if(song != null){
			songService.removeSong(songListId, songId);
		}
	}


}
