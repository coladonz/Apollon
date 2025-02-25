// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import './LiquityMath.sol';
import '../Interfaces/IBase.sol';

/*
 * Base contract for TroveManager, BorrowerOperations. Contains global system constants and
 * common functions.
 */
contract LiquityBase is IBase {
  uint internal constant DECIMAL_PRECISION = 1e18;
  uint public constant MCR = 1.1e18; // 110%, Minimum collateral ratio for individual troves
  uint public constant CCR = 1.5e18; // 150%, Critical system collateral ratio. If the system's total collateral ratio (TCR) falls below the CCR, Recovery Mode is triggered.
  uint public constant COLL_LIQUIDATION_GAS_COMP_PERCENT_DIVISOR = 200; // dividing by 200 yields 0.5%
  uint public constant MAX_BORROWING_FEE = 0.05e18; // 5%
  uint public constant REDEMPTION_FEE_FLOOR = 0.005e18; // 0.5%
  uint public constant SWAP_POOL_AMOUNT_CAP = 100; // based on gas limits
  uint public constant MIN_TROVE_COLL_USD = 10e18; // 10$

  // Return the coll amount of to be drawn from a trove's collateral and sent as gas compensation.
  function _getCollGasCompensation(uint _collAmount) internal pure returns (uint) {
    return _collAmount / COLL_LIQUIDATION_GAS_COMP_PERCENT_DIVISOR;
  }

  function _requireUserAcceptsFee(uint _fee, uint _amount, uint _maxFeePercentage) internal pure {
    if (_fee == 0) return;

    uint feePercentage = (_fee * DECIMAL_PRECISION) / _amount;
    // Fee exceeded provided maximum
    if (feePercentage > _maxFeePercentage) revert FeeExceedMaxPercentage();
  }
}
