enum Role {
  ADMIN, USER


}
extension RoleExt on Role{
  static Role fromString(String role){
    if(role == "ROLE_ADMIN"){
      return Role.ADMIN;
    } else if(role == "ROLE_USER"){
      return Role.USER;
    } else {
      throw Exception();
    }
  }
}