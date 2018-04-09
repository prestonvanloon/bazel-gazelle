# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load(
    "@bazel_gazelle//internal:go_repository.bzl",
    "go_repository",
    _go_repository_tools = "go_repository_tools",
)
load(
    "@bazel_gazelle//internal:overlay_repository.bzl",
    "git_repository",
    "http_archive",
)
load("@bazel_gazelle//third_party:manifest.bzl",
    _manifest = "manifest",
)

def gazelle_dependencies():
  _go_repository_tools(name = "bazel_gazelle_go_repository_tools")

  _maybe(git_repository,
      name = "bazel_skylib",
      remote = "https://github.com/bazelbuild/bazel-skylib",
      commit = "f3dd8fd95a7d078cb10fd7fb475b22c3cdbcb307", # 0.2.0 as of 2017-12-04
  )

  # io_bazel_rules_go also declares this (for now). Keep in sync.
  _maybe(http_archive,
      name = "org_golang_x_tools",
      # release-branch.go1.9, as of 2017-08-25
      urls = ["https://codeload.github.com/golang/tools/zip/5d2fd3ccab986d52112bf301d47a819783339d0e"],
      strip_prefix = "tools-5d2fd3ccab986d52112bf301d47a819783339d0e",
      type = "zip",
      overlay = _manifest["org_golang_x_tools"],
  )

  # TODO(jayconrod): restore when rules_go go_repository_tools no longer
  # requires this to be vendored.
  # _maybe(git_repository,
  #     name = "com_github_pelletier_go_toml",
  #     remote = "https://github.com/pelletier/go-toml",
  #     commit = "16398bac157da96aa88f98a2df640c7f32af1da2", # v1.0.1 as of 2017-12-19
  #     overlay = _manifest["com_github_pelletier_go_toml"],
  # )

def gx_dependencies():
  _maybe(go_repository,
     name = "com_github_whyrusleeping_stump",
     commit = "206f8f13aae1697a6fc1f4a55799faf955971fc5",
     importpath = "github.com/whyrusleeping/stump",
  )

  _maybe(go_repository,
     name = "com_github_mitchellh_go_homedir",
     commit = "b8bc1bf767474819792c23f32d8286a45736f1c6",
     importpath = "github.com/mitchellh/go-homedir",
  )

  _maybe(go_repository,
     name = "com_github_multiformats_go_multiaddr",
     commit = "123a717755e0559ec8fda308019cd24e0a37bb07",
     importpath = "github.com/multiformats/go-multiaddr",
  )

  
def _maybe(repo_rule, name, **kwargs):
  if name not in native.existing_rules():
    repo_rule(name=name, **kwargs)
