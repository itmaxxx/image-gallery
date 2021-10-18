package com.itmax.library.models;

import org.json.simple.JSONObject;

public class Book {
    private String author;
    private String title;

    public String toJsonString() {
        JSONObject res = new JSONObject();
        res.put("author", this.author);
        res.put("title", this.title);
        return res.toString();
    }

    public Book(String author, String title) {
        this.author = author;
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
