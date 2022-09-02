# AAVE-Collateral-Pool

A smart contract based collateral pool. If several friends decide to pool their funds together and any of them want to borrow ERC20 assets. 
The other team members will earn interest on their collateral while also allowing borrowing against it.

## How does this work???
Let's see...

## 1. Membership Dues (Collect DAI)

Let's collect DAI from anyone seeking to join this collateral group. Prospective members will need to contribute 10,000 DAI in order to successfully join.
This DAI will serve as the collateral for any member who wishes to borrow against the group's assets.
After all debts have been paid, members will be able to retrieve their initial deposit plus any interest earned.

Collect $DAI
A. The constructor accepts an array of member addresses as its only parameter. First things first, store this parameter in the members storage variable.
B. For each member in this array, transfer the required depositAmount from their address to the CollateralGroup smart contract.

## 2. Depositing Collateral

Now that all the members have paid their DAI deposit, we can deposit it all into the AAVE lending pool. 
This will allow us to start earning interest on the DAI and also allow it to serve as collateral for future borrows.

### Approve & Deposit
A. In the constructor, deposit all the collected DAI into the pool contract.
B. To do this, you will first need to approve the pool to spend our DAI.
C. Then, deposit the DAI into the pool contract. Deposit it on behalf of the collateral group contract and you can set the referral code to 0 or any valid code you'd like.

## 3. Withdraw

When members are ready to remove their funds, and there are no outstanding loans, anyone can call the withdraw function. This function should kick off a withdrawal for all members. 
For each member it should pay them back their initial deposit plus their share of any interest earned.
The CollateralGroup contract will be holding AAVE interest bearing DAI, or aDai, where the interest earned will be automatically reflected in the token balance. 
To figure out the share for each member, we can simply divide the total aDai balance by the number of members.

### Withdraw From Pool
A. In the withdraw function, withdraw the entire balance of aDai from the pool, distributing the appropriate share to each member who joined the collateral group.
B. Before you can call withdraw on the pool you will need to approve the aDai to be spent by the pool.

## 4. Borrowing ERC20s

After the members have transferred their DAI to the smart contract, let's allow any member to borrow against it. Let's support any ERC20 token that has reserves in the AAVE system.

A. In the CollateralGroup borrow function, call borrow on the AAVE pool to borrow the amount of asset specified by the arguments. Be sure to set the onBehalfOf to the collateral group contract, this way the debt is incurred to the smart contract which holds the collateral. 
B. You can set the referral code as you wish and the interestRateMode should either be 1 for stable or 2 for variable rates.
C. Once you have borrowed the asset, you will need to transfer the ERC20 to the function caller so they can use it. You can use the IERC20 interface to call the asset ERC20 contract in order to make this transfer.

## 5. Repay Loan

When a member is ready to repay their loan, they need to call the repay function. Before calling this function they will need to approve the collateral group to spend the particular asset, otherwise the transfer will fail.

### Transfer and Repay
In the repay function you can repay the loan in three steps:

A. First, transfer the asset from the member to the smart contract.
B. Next, approve the dai to be spent by the pool.
C. In the repay function you can repay the loan in three steps:


Finally, repay the pool on behalf of the collateral group. You will need to choose the same interest rate mode as you did in the borrow function.
