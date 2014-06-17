package com.bizbuzz.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;

@Entity
public class Chat implements Serializable{

  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  @Id
  @GeneratedValue
  private Long id;
  
  private String message;
  
  @ManyToOne
  @JoinColumn(name="chat_room_id", referencedColumnName="id")
  private ChatRoom chatRoom;
  
  @ManyToOne
  @JoinColumn(name="item_id")
  private Item item;

  /**
   * setters and getters
   */
  
  public Long getId(){
    return this.id;
  }
  
  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public ChatRoom getChatRoom() {
    return chatRoom;
  }

  public void setChatRoom(ChatRoom chatRoom) {
    this.chatRoom = chatRoom;
  }

  public Item getItem() {
    return item;
  }

  public void setItem(Item item) {
    this.item = item;
  }
  
}