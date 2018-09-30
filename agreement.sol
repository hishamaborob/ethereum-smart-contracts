pragma solidity ^0.4.6;

contract Agreement {

    address public borrower;
    address public lender;

    struct agreementDocument {

        bool approvedByBorrower;
        bool approvedByLender;
    }

    // Publicly explorable data
    mapping(bytes32 => agreementDocument) public agreementDocuments;
    bytes32[] public documentsList; // all
    bytes32[] public approvedDocuments; // approved

    // Events for listeners
    event LogProposedDocument(address proposer, bytes32 docHash);
    event LogApprovedDocument(address approver, bytes32 docHash);

    // constructor borrower and lender
    function Agreement(address borrowerAddress, address lenderAddress) public {

        borrower = borrowerAddress;
        lender = lenderAddress;
    }

    function getDocumentsCount() public constant returns (uint documentsCount) {

        return documentsList.length;
    }

    function getApprovedDocumentsCount() public constant returns (uint approvedDocumentsCount) {

        return approvedDocuments.length;
    }

    function agreeDocument(bytes32 documentHash) public returns (bool success) {

        require(msg.sender != borrower && msg.sender != lender);

        if (msg.sender == borrower) agreementDocuments[documentHash].approvedByBorrower = true;

        if (msg.sender == lender) agreementDocuments[documentHash].approvedByLender = true;

        if (
            agreementDocuments[documentHash].approvedByBorrower == true &&
            agreementDocuments[documentHash].approvedByLender == true) {

            approvedDocuments.push(documentHash);
            LogApprovedDocument(msg.sender, documentHash);

        } else {

            documentsList.push(documentHash);
            LogProposedDocument(msg.sender, documentHash);
        }
        return true;
    }

}