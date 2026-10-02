{ pkgs, ... }:

{
  # No hashedPassword here: the repo is public. users.mutableUsers is left at
  # its default (true), so the password is managed with `passwd` and kept in
  # /etc/shadow across rebuilds.
  users.users.guillaume = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = "${pkgs.nushell}/bin/nu";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9snyPc+xrQIQbv8ROMHY0BMhN8SDI1pny5xmmEYHbgBOuYETj0XleLOUaosoY2hLQBgfxNokEin7IPA+WieYuX4QhbAK4UZSMmXMk0hMbb+SjtC6vPVTVFaNL3/4yW/WJPlIv5Y+hvyCDRBChlJI+ETVHxxcXLmAc5n7Ket31kDuKB0mrlYSYfM77ydznc+uxJHqgVPIRkFx41QuiM5CBPH9zlF+AaqSxwzOEGYEwuDsCoPuJjml2y17LqSe9dXCGHUOL4MAyRnAeCzfNOa71zP/i6oZ9tR0ixM5L9UXNmYLBTloMQoxkpdZpvrP7VHWnWwQkaUz/daazGW5owmCHvsUogMk1XA2MFStjdS2gCHKK4eXjkiMJeZaCLDKgeIxucDrTCqE44fVl/ajYB2pFLJuSRqtkfftThqYJfQHiqpM5uzjdBfYWESM9hLQfu/jU3F75QVtchZowIwUUHjw4eFWvjmFCVbjx+Tq5kKacAQkqOg1h9f8NwjL8lnx6UAHfKcQNeRIwVI+/JJZkLYrCu9crNcpchP8PfD25JsMTX6ocBt9kaTVHRIWWxj43sEZ4mNgawJmROh0PZ4O5XAhoTpZw82KzvIn8WrVopoxo1cOPp+H6de4/X/xQyEiFXP1dA5TjhHU69ff0CE1YMJSFObWNkO7T7k+f1eWsubPk1Q=="
    ];
  };
}
