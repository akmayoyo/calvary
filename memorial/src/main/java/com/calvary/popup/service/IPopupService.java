package com.calvary.popup.service;

import java.util.List;

import com.calvary.common.vo.UserSearchVo;

public interface IPopupService {

	public List<Object> getUserList(UserSearchVo searchVo);
}
