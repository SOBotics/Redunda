class CodeStatusController < ApplicationController
  def index
    @gem_versions = Gem::Specification.sort_by{ |g| [g.name.downcase, g.version] }.sort_by(&:name)
    @important_gems = [
      "rails",
      "will_paginate",
      "turbolinks"
    ]
  end
  def api
    @repo = Octokit.repository "SOBotics/Redunda"
    @compare = Octokit.compare "SOBotics/Redunda", CurrentCommit, @repo[:default_branch]
    @compare_diff = Octokit.compare "SOBotics/Redunda", CurrentCommit, @repo[:default_branch], accept: "application/vnd.github.v3.diff"
    @commit = Octokit.commit "SOBotics/Redunda", CurrentCommit
    @commit_diff = Octokit.commit "SOBotics/Redunda", CurrentCommit, accept: "application/vnd.github.v3.diff"
  end
end
