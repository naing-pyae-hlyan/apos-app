enum CustomerUpdateAction {
  name("name", "Name"),
  emial("email", "Email"),
  phone("phone", "Phone"),
  address("address", "Address"),
  password("password", "Password");

  final String jsonKey;
  final String label;
  const CustomerUpdateAction(this.jsonKey, this.label);
}
