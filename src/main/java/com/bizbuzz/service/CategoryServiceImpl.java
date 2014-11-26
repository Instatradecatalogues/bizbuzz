package com.bizbuzz.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bizbuzz.model.CategoryTree;
import com.bizbuzz.model.Person;
import com.bizbuzz.model.PropertyMetadata;
import com.bizbuzz.repository.CategoryTreeRepository;
import com.bizbuzz.repository.PropertyMetadataRepository;

@Service
public class CategoryServiceImpl implements CategoryService{
  @Autowired
  CategoryTreeRepository categoryTreeRepository;
  
  @Autowired
  PropertyMetadataRepository propertyMetadataRepository;

  public List<CategoryTree> getAdminCategories(Long parentId){
    return categoryTreeRepository.findAdminCategoriesByParentCategory(parentId);
  }
  
  public List<CategoryTree> getCustomCategories(Long parentId, Long ownerId) {
    return categoryTreeRepository.findCustomCategoriesByParentCategoryAndOwnerId(parentId, ownerId);
  }
  
  public List<CategoryTree> getAllCategories(Long parentId, Long ownerId) {
    List<CategoryTree> adminCategories = getAdminCategories(parentId);
    List<CategoryTree> customCategories = getCustomCategories(parentId, ownerId);
    adminCategories.addAll(customCategories);
    return adminCategories;
  }

  public CategoryTree getCategory(Long id){
    return categoryTreeRepository.findOne(id);
  }
  
  public CategoryTree saveAdminCategory(CategoryTree parentCategory, String categoryName, Boolean isLeaf, Boolean hasProduct){
    CategoryTree category = new CategoryTree();
    category.setCategoryName(categoryName);
    category.setParentCategory(parentCategory);
    category.setIsLeaf(isLeaf);
    category.setIsCustom(false);
    category.setHasProduct(hasProduct);
    categoryTreeRepository.save(category);
    return category;
  }
  
  public CategoryTree saveCustomCategory(CategoryTree parentCategory, String categoryName, Person owner, Boolean hasProduct, Boolean isLeaf){
    CategoryTree category = new CategoryTree();
    category.setCategoryName(categoryName);
    category.setParentCategory(parentCategory);
    category.setIsCustom(true);
    category.setIsLeaf(isLeaf);
    category.setOwner(owner);
    category.setHasProduct(hasProduct);
    categoryTreeRepository.save(category);
    return category;
  }
  
  public CategoryTree updateAdminCategory(Long categoryId, String categoryName, Boolean isLeaf, Boolean hasProduct){
    CategoryTree category = categoryTreeRepository.findOne(categoryId);
    if(categoryName!=null){
      category.setCategoryName(categoryName);
    }
    if(isLeaf!=null){
      category.setIsLeaf(isLeaf);
    }
    if(hasProduct!=null){
      category.setHasProduct(hasProduct);
    }
    categoryTreeRepository.save(category);
    return category;
  }
  
  public CategoryTree updateCustomCategory(Long categoryId, String categoryName, Boolean isLeaf, Boolean hasProduct){
    CategoryTree category = categoryTreeRepository.findOne(categoryId);
    if(categoryName!=null){
      category.setCategoryName(categoryName);
    }
    if(isLeaf!=null){
      category.setIsLeaf(isLeaf);
    }
    if(hasProduct!=null){
      category.setHasProduct(hasProduct);
    }
    categoryTreeRepository.save(category);
    return category;
  }
  
  public void deleteCategory(Long categoryId){
    if(categoryId==null){
      return;
    }
    List<CategoryTree> children = categoryTreeRepository.findAdminCategoriesByParentCategory(categoryId);
    for(int i=0; i<children.size();i++){
      deleteCategory(children.get(i).getId());
    }
    categoryTreeRepository.delete(categoryId);
  }
    
  public List<CategoryTree> getCategories(Person seller, Integer depth, Long categoryId){
    CategoryTree rootCategory = seller.getCategoryRoot();
    if (rootCategory==null){
      return null;
    }
    switch (depth){
    case 1:
      return categoryTreeRepository.findCategoryDepthOne(rootCategory.getId(), categoryId);
    case 2:
      return categoryTreeRepository.findCategoryDepthTwo(rootCategory.getId(), categoryId);
    case 3:
      return categoryTreeRepository.findCategoryDepthThree(rootCategory.getId(), categoryId);
    default:
      return null;
    }
  }
  
  public CategoryTree createCategoryMap(CategoryTree categoryTree){
    if(categoryTree==null){
      return null;
    }
    List<CategoryTree> children = categoryTreeRepository.findAdminCategoriesByParentCategory(categoryTree.getId());
    for(int i=0;i<children.size();i++){
      children.set(i, createCategoryMap(children.get(i)));
    }
    return categoryTree;
  }

  public CategoryTree getCategoryThatHasNearestMetadata(CategoryTree categoryTree){
    if(categoryTree.getIsLeaf()){
      return categoryTree;
    }
    else{
      CategoryTree parent = categoryTree.getParentCategory();
      return getCategoryThatHasNearestMetadata(parent);
    }
  }
  
}
