This is a script for doing dynamic DNS using AWS Route 53.

### Setup

1. Go to Route 53 in AWS and create a Hosted Zone
1. In the configuration enter your domain name and set it to "Public hosted zone"
1. Click your newly created hosted zone and then in the Records list click the button to "Create record"
1. Set record type to "A", enter your subdomain (or set it to empty if there's no subdomain), and put your current IP in the value field
1. Go back to the list of records and click the one that has type "NS"
1. Get values, it should be a list of values that look something like "ns-296.awsdns-37.com."
1. Go to your DNS provider and configure it to use the "ns-*" values
1. `cp env.example .env`
1. Go back to AWS Route 53 and get the id of your Hosted Zone and put it in the `.env` file along with your domain name

### Credits

I used two articles as a foundation for this:
- [How-To-Geek: How to Roll Your Own Dynamic DNS with AWS Route 53](https://www.howtogeek.com/devops/how-to-roll-your-own-dynamic-dns-with-aws-route-53/)
- [Radish Logic: Using GoDaddy Domain in AWS Route 53](https://www.radishlogic.com/aws/using-godaddy-domain-in-aws-route-53/)
