# NAT gateway for the container 

resource "aws_eip" "NatGatewayAIP" {
    vpc = true
    }
resource "aws_nat_gateway" "NatGateWay1A" {
    depends_on = [aws_eip.NatGatewayAIP, aws_subnet.PublicSubNet1]
    allocation_id = aws_eip.NatGatewayAIP.id
    subnet_id = aws_subnet.PublicSubNet1.id
    tags = {
        "Name" = "PublicNatGateway1A"
        }
    }

    
