// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ILendingPool.sol";

contract CollateralGroup {
    ILendingPool pool =
        ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3);

    uint256 depositAmount = 10000e18;
    address[] members;

    constructor(address[] memory _members) {
        members = _members;

        for (uint256 i = 0; i < members.length; i++) {
            dai.transferFrom(members[i], address(this), depositAmount);
        }

        dai.approve(address(pool), type(uint256).max);

        pool.deposit(
            address(dai),
            dai.balanceOf(address(this)),
            address(this),
            0
        );
    }

    modifier callerIsMember() {
        bool isMember = false;
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i] == msg.sender) {
                isMember = true;
                break;
            }
        }
        require(isMember == true, "You Ain't no Member!!!");
        _;
    }

    function withdraw() external callerIsMember {
        uint256 share = aDai.balanceOf(address(this)) / members.length;

        aDai.approve(address(pool), type(uint256).max);

        for (uint256 i = 0; i < members.length; i++) {
            pool.withdraw(address(dai), share, members[i]);
        }
    }

    function borrow(address asset, uint256 amount) external callerIsMember {
        pool.borrow(asset, amount, 1, 0, address(this));

        (, , , , , uint256 healthFactor) = pool.getUserAccountData(
            address(this)
        );
        require(healthFactor > 2e18, "The Borrow is too risky!");

        IERC20(asset).transfer(msg.sender, amount);
    }

    function repay(address asset, uint256 amount) external {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);

        IERC20(asset).approve(address(pool), amount);

        pool.repay(asset, amount, 1, address(this));
    }
}
