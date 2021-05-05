enum Role {
  ADMIN, USER, MODERATOR


}
extension RoleExt on Role{
  static Role fromString(String role){
    if(role == "ROLE_ADMIN"){
      return Role.ADMIN;
    } else if(role == "ROLE_USER"){
      return Role.USER;
    } else if(role == "ROLE_MODERATOR"){
      return Role.MODERATOR;
    } else {
      throw Exception();
    }
  }

  String toStr(){
    switch(this) {
      case Role.ADMIN:
        return "ROLE_ADMIN";
        break;
      case Role.USER:
        return "ROLE_USER";
        break;
      case Role.MODERATOR:
        return "ROLE_MODERATOR";
        break;
    }
  }
}