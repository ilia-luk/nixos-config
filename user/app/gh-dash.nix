{
  pkgs,
  config,
  userSettings,
  ...
}:
with config.lib.stylix.colors;
{
  home.packages = with pkgs; [ (lib.hiPrio unstable.gh-dash) ];

  programs.gh-dash.enable = true;

  programs.gh-dash.settings = {
    repoPaths = {
      "Domusnetwork/accountant" = "/home/${userSettings.username}/dev/accountant/accountant";
      ":owner/:repo" = "/home/${userSettings.username}/dev/:owner/:repo"; # Keep as fallback
    };
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
          updatedAt = {
            width = 5;
          };
          createdAt = {
            width = 5;
          };
          repo = {
            width = 20;
          };
          author = {
            width = 15;
          };
          authorIcon = {
            hidden = false;
          };
          assignees = {
            width = 20;
            hidden = true;
          };
          base = {
            width = 15;
            hidden = true;
          };
          lines = {
            width = 15;
          };
        };
        issues = {
          updatedAt = {
            width = 5;
          };
          createdAt = {
            width = 5;
          };
          repo = {
            width = 15;
          };
          creator = {
            width = 10;
          };
          creatorIcon = {
            hidden = false;
          };
          assignees = {
            width = 20;
            hidden = true;
          };
        };
      };
      refetchIntervalMinutes = 30;
    };
    keybindings = {
      universal = [
        {
          key = "z";
          name = "lazygit";
          command = ''
            zellij run --close-on-exit --floating --width "90%" --height "90%" --cwd {{.RepoPath}} --name "lazygit" -- lazygit
          '';
        }
      ];
      prs = [
        {
          key = "b";
          name = "review (tuicr)";
          command = ''
            zellij run --close-on-exit --floating --width "90%" --height "90%" --cwd {{.RepoPath}} --name "review-{{.PrNumber}}" -- tuicr pr {{.PrNumber}}
          '';
        }
        {
          key = "E";
          name = "checkout worktree";
          # nu -e: run then stay interactive — wt's cd handshake works, the
          # floating pane lands IN the worktree; launch nvim/pi/etc from there
          command = ''
            zellij run --close-on-exit --floating --width "90%" --height "90%" --cwd {{.RepoPath}} --name "PR-{{.PrNumber}}" -- nu -e "wt switch pr:{{.PrNumber}}"
          '';
        }
        {
          key = "B";
          name = "agent review (pi)";
          # left: tuicr on the PR (host side — session pre-opened for you);
          # right: jailed pi in a PR worktree, handed the exact session slug
          command = ''
            zellij run --close-on-exit --floating --x 0 --y 0 --width "50%" --height "95%" --cwd {{.RepoPath}} --name "tuicr-{{.PrNumber}}" -- tuicr pr {{.PrNumber}}; zellij run --close-on-exit --floating --x "50%" --y 0 --width "50%" --height "95%" --cwd {{.RepoPath}} --name "agent-review-{{.PrNumber}}" -- nu -e "wt switch pr:{{.PrNumber}}; pi 'A tuicr review session for this PR is already open beside me (slug: gh:{{.RepoName}}/pr/{{.PrNumber}}). Review this branch diff against main and post each finding via tuicr review add --username pi --session gh:{{.RepoName}}/pr/{{.PrNumber}}. If that session is not yet listed as active, wait a few seconds and re-check tuicr review list.'"
          '';
        }
      ];
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
        background = {
          selected = "#${base02}";
        };
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
    pager = {
      diff = "diffnav";
    };
    confirmQuit = false;
    showAuthorIcons = true;
    smartFilteringAtLaunch = true;
  };
}
