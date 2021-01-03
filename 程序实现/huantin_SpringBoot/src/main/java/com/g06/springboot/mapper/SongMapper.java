package com.g06.springboot.mapper;

import com.g06.springboot.entity.Song;
import org.springframework.stereotype.Repository;

/**
 *@Description 歌曲Mapper接口
 *@Author ZSY
 *@Date 2020/12/27 22:33
 */
@Repository
public interface SongMapper {
	/**
	 * 检查该首歌曲是否已存在歌单
	 * @param songListId:歌单号
	 * @param songId:歌曲号
	 * @param platformType:平台类型
	 * @return Song
	 **/
	Song checkSong(int songListId,String songId, String platformType);

	/**
	 * 添加歌曲进歌单
	 * @param songListId:歌单号
	 * @param songId:歌曲号
	 * @param platform:平台类型
	 * @return void
	 **/
	void addSong(int songListId, String songId, String platform);

	/**
	 * 删除歌单里的歌曲
	 * @param songListId:歌单号
	 * @param songId:歌曲号
	 * @return void
	 **/
	void removeSong(int songListId, String songId);
}
