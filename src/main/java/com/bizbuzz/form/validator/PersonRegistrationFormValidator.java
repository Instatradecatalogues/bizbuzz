package com.bizbuzz.form.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.bizbuzz.dto.RegistrationPersonRegistrationFormDTO;
import com.bizbuzz.repository.UserLoginRepository;



public class PersonRegistrationFormValidator implements Validator{

  @Autowired
  UserLoginRepository userLoginRepository;
  
  @Override
  public boolean supports(Class<?> paramClass) {
    return RegistrationPersonRegistrationFormDTO.class.equals(paramClass);
  }

  @Override
  public void validate(Object obj, Errors errors) {
    ValidationUtils.rejectIfEmptyOrWhitespace(errors, "person.firstName", "person.firstname.required");
    
    RegistrationPersonRegistrationFormDTO object = (RegistrationPersonRegistrationFormDTO)obj;
    if(userLoginRepository.findById(object.getUserLogin().getId()) != null){
      errors.rejectValue("userLogin.id", "userLogin.id.duplicate");
    }
  }
}
