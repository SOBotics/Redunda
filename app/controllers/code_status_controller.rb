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
    @repo = Rails.cache.fetch "code_status/repo##{CurrentCommit}" do
      Octokit.repository "SOBotics/Redunda"
    end
    @compare = Rails.cache.fetch "code_status/compare##{CurrentCommit}" do
      Octokit.compare "SOBotics/Redunda", CurrentCommit, @repo[:default_branch]
    end
    @compare_diff = Rails.cache.fetch "code_status/compare_diff##{CurrentCommit}" do
      Octokit.compare "SOBotics/Redunda", CurrentCommit, @repo[:default_branch], accept: "application/vnd.github.v3.diff"
    end
    @commit = Rails.cache.fetch "code_status/commit##{CurrentCommit}" do
      Octokit.commit "SOBotics/Redunda", CurrentCommit
    end
    @commit_diff = Rails.cache.fetch "code_status/commit_diff##{CurrentCommit}" do
      Octokit.commit "SOBotics/Redunda", CurrentCommit, accept: "application/vnd.github.v3.diff"
    end
  end
end
