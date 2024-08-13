package com.example.nego.dto;

import java.util.List;

import lombok.Data;

@Data
public class CateDTO {
	private int id;
	private String name;
	private int parent_id;
	private int category_level;
	private List<CateDTO> subList;
	private List<CateDTO> itemList;

}
