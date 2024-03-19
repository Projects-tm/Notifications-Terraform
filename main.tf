//
// Copyright 2024, TeamDev. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Redistribution and use in source and/or binary forms, with or without
// modification, must retain the above copyright notice and the following
// disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

locals {

  // Docker image of the Notifications server.
  notifications_image = "europe-docker.pkg.dev/our-tasks-infr/notifications/notifications"
}

resource "google_cloud_run_v2_service" "notifications_service" {
  name     = var.name
  location = var.region
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  launch_stage = "BETA"

  template {
    containers {
      image = local.notifications_image

      env {
        name = "notifications.telegram.token"
        value = var.telegram_token
      }
      ports {
        container_port = 80
      }
    }

    vpc_access {
      network_interfaces {
        network    = var.vpc_network
        subnetwork = var.vpc_subnetwork
      }
    }
  }
}

// Creates policy for the unauthenticated requests to the Notifications service.
resource "google_cloud_run_v2_service_iam_policy" "notifications_access_policy" {
  project     = var.project_id
  name        = google_cloud_run_v2_service.notifications_service.name
  location    = var.region
  policy_data = data.google_iam_policy.notifications_invoker_policy.policy_data
}

data "google_iam_policy" "notifications_invoker_policy" {
  binding {
    members = ["allUsers"]
    role    = "roles/run.invoker"
  }
}
