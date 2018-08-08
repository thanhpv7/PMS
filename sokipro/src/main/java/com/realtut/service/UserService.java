package com.realtut.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.realtut.dao.UserDao;
import com.realtut.model.Users;

@Service("userService")
public class UserService {
    @Autowired
    private UserDao userDao;

    public boolean isUsers(String username, String password) {
        Users user = userDao.findByUserName(username);
        if (user != null && user.getPassword().equals(password)) {
            return true;
        }
        return false;
    }

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
}
