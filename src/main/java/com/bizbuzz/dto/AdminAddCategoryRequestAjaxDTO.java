package com.bizbuzz.dto;

public class AdminAddCategoryRequestAjaxDTO {
  private String categoryName;
  private Long parentId;
  private Boolean isLeaf;
  public String getCategoryName() {
    return categoryName;
  }
  public void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }
  public Long getParentId() {
    return parentId;
  }
  public void setParentId(Long parentId) {
    this.parentId = parentId;
  }
  public Boolean getIsLeaf() {
    return isLeaf;
  }
  public void setIsLeaf(Boolean isLeaf) {
    this.isLeaf = isLeaf;
  }
  
}
