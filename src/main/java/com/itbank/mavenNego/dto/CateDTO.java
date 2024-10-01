package com.itbank.mavenNego.dto;

import java.util.List;

public class CateDTO {
	private int id;
	private String name;
	private int parent_id;
	private int category_level;
	private List<CateDTO> subList;
	private List<CateDTO> itemList;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getParent_id() {
		return parent_id;
	}
	public void setParent_id(int parent_id) {
		this.parent_id = parent_id;
	}
	public int getCategory_level() {
		return category_level;
	}
	public void setCategory_level(int category_level) {
		this.category_level = category_level;
	}
	
	
	public List<CateDTO> getSubList() {
		return subList;
	}
	public void setSubList(List<CateDTO> subList) {
		this.subList = subList;
		
	}
	public List<CateDTO> getItemList() {
		return itemList;
	}
	public void setItemList(List<CateDTO> itemList) {
		this.itemList = itemList;
	}
	
	
}
