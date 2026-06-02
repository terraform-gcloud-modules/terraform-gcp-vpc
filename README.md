# Terraform GCP VPC

[![Latest Release](https://img.shields.io/github/release/terraform-gcloud-modules/terraform-gcp-vpc.svg)](https://github.com/terraform-gcloud-modules/terraform-gcp-vpc/releases/latest)
[![tfsec](https://github.com/terraform-gcloud-modules/terraform-gcp-vpc/actions/workflows/security-tfsec.yml/badge.svg)](https://github.com/terraform-gcloud-modules/terraform-gcp-vpc/actions/workflows/security-tfsec.yml)
[![License](https://img.shields.io/badge/License-APACHE-blue.svg)](LICENSE)
[![Changelog](https://img.shields.io/badge/Changelog-blue)](CHANGELOG.md)

Terraform module for creating and managing a Google Cloud VPC network and its network-level resources.

This module creates a custom-mode VPC network with support for Shared VPC, VPC Peering, private IP allocation for managed services (Cloud SQL, Memorystore), private service networking connections,  resources are managed by their own dedicated modules and consume outputs from this module.

## Requirements

| Name | Version |
|------|---------|
| Terraform | `>= 1.14, < 2.0` |
| Google provider | `>= 4.64, < 8` |

## Resources

This module can create:

- `google_compute_network`
- `google_compute_shared_vpc_host_project`
- `google_service_networking_connection`


It also uses the [`terraform-gcp-labels`](https://github.com/terraform-gcloud-modules/terraform-gcp-labels) module for name and label generation.

## Usage

### Basic VPC

```hcl
module "vpc" {
  source = "github.com/terraform-gcloud-modules/terraform-gcp-vpc"

  name        = "myapp"
  environment = "dev"
  label_order = ["name", "environment"]

  project_id              = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}
```

### Cloud NAT with MANUAL_ONLY IPs

```hcl
module "vpc" {
  source = "github.com/terraform-gcloud-modules/terraform-gcp-vpc"

  name        = "myapp"
  environment = "prod"
  label_order = ["name", "environment"]

  project_id = var.project_id

  enable_nat             = true
  region                 = "us-central1"
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.nat_ip.self_link]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
```


See [`examples/complete`](examples/complete) for a runnable example covering all features.

## Module Architecture

This module is **VPC-scoped only**. Subnet, firewall, and DNS resources belong to their own modules and reference outputs from this module:


## 📑 Changelog

Refer [here](CHANGELOG.md).




## ✨ Contributors

Big thanks to our contributors for elevating our project with their dedication and expertise! But, we do not wish to stop there, would like to invite contributions from the community in improving these projects and making them more versatile for better reach. Remember, every bit of contribution is immensely valuable, as, together, we are moving in only 1 direction, i.e. forward. 

<a href="https://github.com/clouddrove/terraform-module-template/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=clouddrove/terraform-module-template&max" />
</a>
<br>
<br>

 If you're considering contributing to our project, here are a few quick guidelines that we have been following (Got a suggestion? We are all ears!):

- **Fork the Repository:** Create a new branch for your feature or bug fix.
- **Coding Standards:** You know the drill.
- **Clear Commit Messages:** Write clear and concise commit messages to facilitate understanding.
- **Thorough Testing:** Test your changes thoroughly before submitting a pull request.
- **Documentation Updates:** Include relevant documentation updates if your changes impact it.


## Feedback 
Spot a bug or have thoughts to share with us? Let's squash it together! Log it in our [issue tracker](https://github.com/clouddrove/terraform-module-template/issues), feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

Show some love with a ★ on [our GitHub](https://github.com/clouddrove/terraform-module-template)!  if our work has brightened your day! – your feedback fuels our journey!


## :rocket: Our Accomplishment

We have [*100+ Terraform modules*][terraform_modules] 🙌. You could consider them finished, but, with enthusiasts like yourself, we are able to ever improve them, so we call our status - improvement in progress.

- [Terraform Module Registry:](https://registry.terraform.io/namespaces/clouddrove) Discover our Terraform modules here.

- [Terraform Modules for AWS/Azure Modules:](https://github.com/clouddrove/toc) Explore our comprehensive Table of Contents for easy navigation through our documentation for modules pertaining to AWS, Azure & GCP. 

- [Terraform Modules for Digital Ocean:](https://github.com/terraform-do-modules/toc) Check out our specialized Terraform modules for Digital Ocean.




## Join Our Slack Community

Join our vibrant open-source slack community and embark on an ever-evolving journey with CloudDrove; helping you in moving upwards in your career path.
Join our vibrant Open Source Slack Community and embark on a learning journey with CloudDrove. Grow with us in the world of DevOps and set your career on a path of consistency.

🌐💬What you'll get after joining this Slack community:

- 🚀 Encouragement to upgrade your best version.
- 🌈 Learning companionship with our DevOps squad.
- 🌱 Relentless growth with daily updates on new advancements in technologies.

Join our tech elites [Join Now][slack] 🚀


## Explore Our Blogs

 Click [here][blog] :books: :star2:

## Tap into our capabilities
We provide a platform for organizations to engage with experienced top-tier DevOps & Cloud services. Tap into our pool of certified engineers and architects to elevate your DevOps and Cloud Solutions. 

At [CloudDrove][website], has extensive experience in designing, building & migrating environments, securing, consulting, monitoring, optimizing, automating, and maintaining complex and large modern systems. With remarkable client footprints in American & European corridors, our certified architects & engineers are ready to serve you as per your requirements & schedule. Write to us at [business@clouddrove.com](mailto:business@clouddrove.com).

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://registry.terraform.io/namespaces/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [blog]: https://blog.clouddrove.com
  [slack]: https://www.launchpass.com/devops-talks
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
