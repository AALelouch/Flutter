class Users {
  String Name;
  String LastName;
  String Emoji;
  String Image;
  String Email;
  String Role;
  String Active;
  Users(this.LastName, this.Emoji, this.Name, this.Image, this.Email, this.Role,
      this.Active);

  Users.fromJson(Map<String, dynamic> json)
      : LastName = json['LastName'],
        Emoji = json['Emoji'],
        Name = json['Name'],
        Image = json['Image'],
        Email = json['Email'],
        Role = json['Role'],
        Active = json['Active'];
        
  Map<String, dynamic> toJson() => {
    'LastName' :LastName,
    'Emoji':Emoji,
    'Name':Name,
    'Image':Image,
    'Email':Email,
    'Role':Role,
    'Active':Active
  };
}
