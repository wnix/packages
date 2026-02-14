{ pkgs, self }:

{
  seatsurfing-module = pkgs.testers.nixosTest {
    name = "seatsurfing";
    nodes.machine =
      { lib, ... }:
      {
        imports = [ self.nixosModules.seatsurfing ];

        services.seatsurfing = {
          enable = true;
          settings = {
            POSTGRES_URL = "postgres://seatsurfing@localhost/seatsurfing?sslmode=disable";
            INIT_ORG_PASS = "testpassword123";
          };
        };

        systemd.services.seatsurfing = {
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "seatsurfing" ];
          ensureUsers = [
            {
              name = "seatsurfing";
              ensureDBOwnership = true;
            }
          ];
          authentication = lib.mkBefore ''
            host seatsurfing seatsurfing 127.0.0.1/32 trust
            host seatsurfing seatsurfing ::1/128      trust
          '';
        };
      };

    testScript = ''
      machine.wait_for_unit("postgresql.service")
      machine.wait_for_unit("seatsurfing.service")
      machine.wait_for_open_port(8080)
      machine.succeed("curl -sf http://127.0.0.1:8080/")
    '';
  };
}
