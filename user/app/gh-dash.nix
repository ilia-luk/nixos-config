{ pkgs, config, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ (lib.hiPrio unstable.gh-dash) ];

  programs.gh-dash.enable = true;

  programs.gh-dash.settings = {
    prSections = [
      {
        title = "My Pull Requests";
        filters = "is:open";
      }
      {
        title = "Needs My Review";
        filters = "is:open review-requested:@me";
      }
      {
        title = "Involved";
        filters = "is:open involves:@me -author:@me";
      }
    ];

    issuesSections = [
      {
        title = "My Issues";
        filters = "is:open author:@me";
      }
      {
        title = "Assigned";
        filters = "is:open assignee:@me";
      }
      {
        title = "Involved";
        filters = "is:open involves:@me -author:@me";
      }
    ];
    notificationsSections = [
      {
        title = "All";
        filters = "";
      }
      {
        title = "Created";
        filters = "reason:author";
      }
      {
        title = "Participating";
        filters = "reason:participating";
      }
      {
        title = "Mentioned";
        filters = "reason:mention";
      }
      {
        title = "Review Requested";
        filters = "reason:review-requested";
      }
      {
        title = "Assigned";
        filters = "reason:assign";
      }
      {
        title = "Subscribed";
        filters = "reason:subscribed";
      }
      {
        title = "Team Mentioned";
        filters = "reason:team-mention";
      }
    ];
    repo = {
      branchesRefetchIntervalSeconds = 30;
      prsRefetchIntervalSeconds = 60;
    };
    defaults = {
      preview = {
        open = false;
        width = 70;
      };
      prsLimit = 20;
      prApproveComment = "LGTM";
      issuesLimit = 20;
      notificationsLimit = 20;
      view = "prs";
      layout = {
        prs = {
          updatedAt = { width = 5; };
          createdAt = { width = 5; };
          repo = { width = 20; };
          author = { width = 15; };
          authorIcon = { hidden = false; };
          assignees = {
            width = 20;
            hidden = true;
          };
          base = {
            width = 15;
            hidden = true;
          };
          lines = { width = 15; };
        };
        issues = {
          updatedAt = { width = 5; };
          createdAt = { width = 5; };
          repo = { width = 15; };
          creator = { width = 10; };
          creatorIcon = { hidden = false; };
          assignees = {
            width = 20;
            hidden = true;
          };
        };
      };
      refetchIntervalMinutes = 30;
    };
    keybindings = {
      universal = [{
        key = "g";
        name = "lazygit";
        command = "> cd {{.RepoPath}}; lazygit";
      }];
      prs = [{
        key = "C";
        name = "code review";
        command =
          "> zellij run --floating --cwd {{.RepoPath}} --name \"PR-{{.PrNumber}}\" -- nu -c 'gh pr checkout {{.PrNumber}}; nvim'";
      }];
    };
    theme = {
      colors = {
        text = {
          primary = "#${base05}";
          secondary = "#${base0F}";
          inverted = "#${base21}";
          faint = "#${base18}";
          warning = "#${base0A}";
          success = "#${base0B}";
          error = "#${base08}";
        };
        background = { selected = "#${base02}"; };
        border = {
          primary = "#${base0F}";
          secondary = "#${base03}";
          faint = "#${base02}";

        };
      };
      ui = {
        sectionsShowCount = true;
        table = {
          showSeparator = true;
          compact = true;
        };

      };
    };
    pager = { diff = "diffnav"; };
    confirmQuit = false;
    showAuthorIcons = true;
    smartFilteringAtLaunch = true;
  };
}
