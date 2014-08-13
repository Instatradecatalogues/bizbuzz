package com.bizbuzz.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bizbuzz.model.CategoryTree;
import com.bizbuzz.model.Connection.ConnectionType;
import com.bizbuzz.model.Item;
import com.bizbuzz.model.Person;
import com.bizbuzz.model.PropertyMetadata;
import com.bizbuzz.model.PropertyValue;
import com.bizbuzz.repository.ImageModelRepository;
import com.bizbuzz.repository.ItemRepository;
import com.bizbuzz.repository.PropertyValueRepository;

@Service
public class ItemServiceImpl implements ItemService{
  @Autowired
  ImageModelRepository imageModelRepository;
  @Autowired
  PropertyValueRepository propertyValueRepository;
  @Autowired
  ItemRepository itemRepository;
  
  public Item saveItem(Item item){
    return itemRepository.saveAndFlush(item);
  }
  
  public Item getItemByItemIdAndOwner(Long itemId, Person owner){
    return itemRepository.findItemByIdAndOwnerId(itemId, owner.getId());
  }
  
  public List<Item> getItemsByCategoryIdAndOwner(Long categoryId, Long ownerId){
    return itemRepository.findItemsByCategoryIdAndOwnerId(categoryId, ownerId);
  }
   
  public List<Item> getItemsOfAllSellersByCategoryAndBuyer(CategoryTree category, Person buyer){
    //return itemRepository.findItemsByCategoryIdAndBuyerIdAndConnectionType(category.getId(), buyer.getId(), ConnectionType.SELLER_BUYER);
    return null;
  }
  
}