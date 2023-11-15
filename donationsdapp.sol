// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract DonationCampaign {
    // Variables
    // Donaciones
    struct Donation {
        address donorAddress;
        string commentary;
        uint256 donationDate;
        uint256 donationAmount;
    }

    // Campana
    uint256 public numDonors;
    uint256 public totalRaised;
    string public cause;
    string public causeDescription;
    address public beneficiaryAddress;
    uint256 public campaignStartTime;
    uint256 public campaignDuration;

    // Mapeo de ID de campana a donaciones
    mapping(uint256 => Donation[]) public campaignDonations;

    // Constructor
    constructor() {
        // Inicializar el tiempo de inicio de la campana al desplegar el contrato
        campaignStartTime = block.timestamp;
    }

    // Funciones de escritura
    function crearCampana(
        string memory _cause,
        string memory _causeDescription,
        address _beneficiaryAddress,
        uint256 _campaignDuration
    ) public {
        cause = _cause;
        causeDescription = _causeDescription;
        beneficiaryAddress = _beneficiaryAddress;
        campaignDuration = _campaignDuration;
    }

    function donar(uint256 _campaignId, string memory _commentary) public payable {
        require(
            block.timestamp >= campaignStartTime && block.timestamp <= campaignStartTime + campaignDuration,
            "Las donaciones solo se pueden realizar durante la campana."
        );
        require(msg.value > 0, "La donacion debe ser mayor que 0");

        // Registrar la donación para la campana específica
        campaignDonations[_campaignId].push(Donation({
            donorAddress: msg.sender,
            commentary: _commentary,
            donationDate: block.timestamp,
            donationAmount: msg.value
        }));

        numDonors++;
        totalRaised += msg.value;
    }

    function retiroDeFondos() public {
        require(msg.sender == beneficiaryAddress, "Solo el beneficiario puede retirar fondos");

        // Transferir fondos al beneficiario en cualquier momento
        payable(beneficiaryAddress).transfer(address(this).balance);
    }

    // Funciones de lectura
    function informacionDeCampana() public view returns (
        uint256,
        uint256,
        string memory,
        string memory,
        address,
        uint256,
        uint256
    ) {
        return (numDonors, totalRaised, cause, causeDescription, beneficiaryAddress, campaignDuration, campaignStartTime);
    }

    function donacionesDeCampana(uint256 _campaignId) public view returns (Donation[] memory) {
        return campaignDonations[_campaignId];
    }

}
