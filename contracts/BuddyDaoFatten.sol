
// File: contracts/interface/IPancakeswapV2Factory.sol


pragma solidity ^0.8.0;

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
// File: contracts/library/Address.sol



pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value:amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value:value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
// File: contracts/library/SafeMath.sol



pragma solidity ^0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

}
// File: contracts/interface/IERC20.sol



pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

      /**
     * EXTERNAL FUNCTION
     *
     * @dev change token name
     * @param _name token name
     * @param _symbol token symbol
     *
     */
    function changeTokenName(string calldata _name, string calldata _symbol)external;

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: contracts/library/SafeErc20.sol



pragma solidity ^0.8.0;





/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
// File: contracts/library/SafeTransfer.sol



pragma solidity ^0.8.0;


contract SafeTransfer{

    using SafeERC20 for IERC20;
    event Redeem(address indexed recieptor,address indexed token,uint256 amount);

    /**
     * @notice  transfers money to the pool
     * @dev function to transfer
     * @param token of address
     * @param amount of amount
     * @return return amount
     */
    function getPayableAmount(address token, address from, address to, uint256 amount) internal returns (uint256) {
        if (token == address(0)){
            amount = msg.value;
        }else if (amount > 0){
            IERC20 oToken = IERC20(token);
            oToken.safeTransferFrom(from, to, amount);
        }
        return amount;
    }

    /**
     * @dev An auxiliary foundation which transter amount stake coins to recieptor.
     * @param recieptor account.
     * @param token address
     * @param amount redeem amount.
     */
    function _redeem(address payable recieptor,address token,uint256 amount) internal{
        if (token == address(0)){
            recieptor.transfer(amount);
        }else{
            IERC20 oToken = IERC20(token);
            oToken.safeTransfer(recieptor,amount);
        }
        emit Redeem(recieptor,token,amount);
    }
}
// File: @chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol


pragma solidity ^0.8.0;

interface AutomationCompatibleInterface {
  /**
   * @notice method that is simulated by the keepers to see if any work actually
   * needs to be performed. This method does does not actually need to be
   * executable, and since it is only ever simulated it can consume lots of gas.
   * @dev To ensure that it is never called, you may want to add the
   * cannotExecute modifier from KeeperBase to your implementation of this
   * method.
   * @param checkData specified in the upkeep registration so it is always the
   * same for a registered upkeep. This can easily be broken down into specific
   * arguments using `abi.decode`, so multiple upkeeps can be registered on the
   * same contract and easily differentiated by the contract.
   * @return upkeepNeeded boolean to indicate whether the keeper should call
   * performUpkeep or not.
   * @return performData bytes that the keeper should call performUpkeep with, if
   * upkeep is needed. If you would like to encode data to decode later, try
   * `abi.encode`.
   */
  function checkUpkeep(bytes calldata checkData) external returns (bool upkeepNeeded, bytes memory performData);

  /**
   * @notice method that is actually executed by the keepers, via the registry.
   * The data returned by the checkUpkeep simulation will be passed into
   * this method to actually be executed.
   * @dev The input to this method should not be trusted, and the caller of the
   * method should not even be restricted to any single registry. Anyone should
   * be able call it, and the input should be validated, there is no guarantee
   * that the data passed in is the performData returned from checkUpkeep. This
   * could happen due to malicious keepers, racing keepers, or simply a state
   * change while the performUpkeep transaction is waiting for confirmation.
   * Always validate the data passed in.
   * @param performData is the data which was passed back from the checkData
   * simulation. If it is encoded, it can easily be decoded into other types by
   * calling `abi.decode`. This data should not be trusted, and should be
   * validated against the contract's current state.
   */
  function performUpkeep(bytes calldata performData) external;
}

// File: @chainlink/contracts/src/v0.8/AutomationBase.sol


pragma solidity ^0.8.0;

contract AutomationBase {
  error OnlySimulatedBackend();

  /**
   * @notice method that allows it to be simulated via eth_call by checking that
   * the sender is the zero address.
   */
  function preventExecution() internal view {
    if (tx.origin != address(0)) {
      revert OnlySimulatedBackend();
    }
  }

  /**
   * @notice modifier that allows it to be simulated via eth_call by checking
   * that the sender is the zero address.
   */
  modifier cannotExecute() {
    preventExecution();
    _;
  }
}

// File: @chainlink/contracts/src/v0.8/AutomationCompatible.sol


pragma solidity ^0.8.0;



abstract contract AutomationCompatible is AutomationBase, AutomationCompatibleInterface {}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/BuddyDao.sol


pragma solidity ^0.8.0;








contract BuddyDao is Ownable, Pausable, ReentrancyGuard, SafeTransfer, AutomationCompatibleInterface {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 public TimeInterval;
    // Initial time per timing
    uint256 public StartTimeInterval;

    // Monthly fee rate
    uint256 public ServiceFee;
    // todo: not enabled
    address public ServiceFeeAddress;
    // Max Annual Rate or Monthly Interest Rate，Default is 100%
    uint256 public MaxFixedRate = 1e18;
    uint256 constant baseDecimal = 1e18;
    // Default is Base Years APR
    uint256 public baseYearOrMonth = 365 days;

    // lend info
    struct Lender {
        // approve address
        address Address;
        address Token;
        uint256 FixedRate;
        uint256 CreditLine;
        uint256 Amount;
        // Whether to completely deauthorize
        bool isCancel;
    }

    // borrower info
    struct Borrower {
        address Creditors;
        address Token;
        uint256 FixedRate;
        uint256 CreditLine;
        uint256 Amount;
        // Whether to completely deauthorize
        bool isCancel;
    }


    // total borrower info
    address[] public totalBorrower;
    mapping(address => bool) public isTotalBorrower;

    mapping(address =>mapping(address => bool)) public BorrowerBool;
    mapping(address => address[]) public BorrowerArrary;

    mapping(address => mapping(address => mapping(uint256 => bool))) public TotalBorrowerBool;
    mapping(address => mapping(address => uint256[])) public TotalBorrowerIndexArrary;


    // Lender homepage data
    mapping(address => mapping(address => Lender[])) public LenderData;
    // Borrower homepage data
    mapping(address => mapping(address => Borrower[]))  public BorrowerData;

    // lend info
    mapping (address => address[]) public LenderNumber;
    // borrower info
    mapping (address => address[]) public BorrowerNumber;

    // key has been added or not
    mapping (address => mapping(address => bool)) public LenderIsBool;
    mapping (address => mapping(address => bool)) public BorrowerIsBool;



    // log
    event SetBaseUnit(uint256 _oldBase, uint256 _newBase);
    event SetTimeInterval(uint256 _oldTimeInternal, uint256 _newTimeInternal);
    event SetServiceFee(uint256 _old, uint256 _new);
    event SetServiceFeeAddress(address _oldAddress, address _newAddress);
    event SetMaxFixedRate(uint256 _oldFixedRate, uint256 _newFixedRate);
    event Trust(address indexed _address, address _token, uint256 indexed  _fixedRate, uint256 indexed _amount);
    event ReduceTrust(address _approveAddress, uint256 _index, uint256 _cancelAmount);
    event WithdrawAssets(address _lendAddress, uint256 _index, uint256 _borrowerAmount);
    event Payment(address _lendAddress, uint256 _index, uint256 _payAmount);


    constructor (uint256 _serviceFee, address _serviceFeeAddress, uint256 _maxFixedRate) {
        require(_serviceFee != 0, "serviceFee must be a positive number");
        require(_serviceFee <= MaxFixedRate, "Cannot exceed the maximum interest rate");
        ServiceFeeAddress = _serviceFeeAddress;
        MaxFixedRate = _maxFixedRate;
        ServiceFee = _serviceFee;
        StartTimeInterval = block.timestamp;
    }

    function setBaseUnit(uint256 _newBaseUnit) external onlyOwner {
        require(_newBaseUnit > 0, "New base uint must be great 0");
        emit SetBaseUnit(baseYearOrMonth, _newBaseUnit);
        baseYearOrMonth = _newBaseUnit;
    }

    function setTimeInterval(uint256 _newTimeInterval) external onlyOwner {
        require(_newTimeInterval > 0, "New Time Interval must be great 0");
        emit SetTimeInterval(TimeInterval, _newTimeInterval);
        TimeInterval = _newTimeInterval;
    }


    function setServiceFee(uint256 _serviceFee) external onlyOwner {
        require(_serviceFee !=0, "serviceFee must be a positive number");
        require(_serviceFee <= MaxFixedRate, "Cannot exceed the maximum interest rate");
        emit SetServiceFee(ServiceFee, _serviceFee);
        ServiceFee = _serviceFee;
    }

    function setServiceFeeAddress(address _newAddress) external onlyOwner {
        require(_newAddress != address(0), "serviceFeeAddress is not a zero address");
        emit SetServiceFeeAddress(ServiceFeeAddress, _newAddress);
        ServiceFeeAddress = _newAddress;
    }

    function setMaxFixedRate(uint256 _maxFixedRate) external onlyOwner {
        require(_maxFixedRate >= 0, "maxFixedRate must be greater than or equal to 0");
        emit SetMaxFixedRate(MaxFixedRate, _maxFixedRate);
        MaxFixedRate = _maxFixedRate;
    }


    // Get Lender Info
    function GetLenderAddressLengeth(address _lenderAddress) public view returns(uint256) {
        uint256 lenLender = (LenderNumber[_lenderAddress]).length;
        return lenLender;
    }

    // Get Lender Address
    function GetLenderAddress(address _lenderAddress) public view returns(address[] memory){
        return LenderNumber[_lenderAddress];
    }

    // Get Lends Homepage Data
    function GetLenderData(address _lenderAddress, address _approveAddress) public view returns (Lender[] memory ) {
        Lender[] memory lenderAddressData = LenderData[_lenderAddress][_approveAddress];
        return lenderAddressData;
    }
    // Get Lender Index Info
    function GetLenderIndexData(address _lenderAddress, address _approveAddress, uint256 _index) public view returns (Lender memory) {
        Lender memory lenderAddressData = LenderData[_lenderAddress][_approveAddress][_index];
        return lenderAddressData;
    }


    // Get Borrower Info
    function GetBorrowerAddressLengeth(address _borrowerAddress) public view returns(uint256) {
        uint256 lenBorrower = (BorrowerNumber[_borrowerAddress]).length;
        return lenBorrower;
    }

    // Get Borrower Address
    function GetBorrowerAddress(address _borrowerAddress) public view returns(address[] memory) {
        return BorrowerNumber[_borrowerAddress];
    }

    // Get Borrower Homepage Data
    function GetBorrowerData(address _borrowerAddress, address _creditors) public view returns (Borrower[] memory) {
        Borrower[] memory borrowerAddressData = BorrowerData[_borrowerAddress][_creditors];
        return borrowerAddressData;
    }

    // Get Borrower Index Info
    function GetBorrowerIndexData(address _borrowerAddress, address _creditors, uint256 _index) public view returns (Borrower memory) {
        Borrower memory borrowerAddressData = BorrowerData[_borrowerAddress][_creditors][_index];
        return borrowerAddressData;
    }


    function NewTrust(address _approveAddress, address _token, uint256 _fixedRate, uint256 _amount) external nonReentrant whenNotPaused {
        require(_approveAddress != address(0), "_approveAddress is not a zero address");
        require(_token != address(0), "_token is not a zero address");
        require(_fixedRate <= MaxFixedRate, "Must be less than the maximum interest");
        require(_approveAddress != msg.sender, "approve address is not msg.sender");

        uint256 allowBalance = IERC20(_token).allowance(msg.sender, address(this));
        require(_amount <= allowBalance, "Lend lack of allowance");

        uint256 erc20Balance = IERC20(_token).balanceOf(msg.sender);
        require(_amount <= erc20Balance, "The authorized quantity must be greater than the balance");

        bool resultLender = LenderIsBool[msg.sender][_approveAddress];
        if (!resultLender){
            LenderIsBool[msg.sender][_approveAddress] = !LenderIsBool[msg.sender][_approveAddress];
            LenderNumber[msg.sender].push(_approveAddress);
        }
        bool resultBorrower = BorrowerIsBool[_approveAddress][msg.sender];
        if (!resultBorrower){
            BorrowerIsBool[_approveAddress][msg.sender] = !BorrowerIsBool[_approveAddress][msg.sender];
            BorrowerNumber[_approveAddress].push(msg.sender);
        }

        // save lend info
        Lender[] storage lendInfo = LenderData[msg.sender][_approveAddress];
        lendInfo.push(Lender({
            Address: _approveAddress,
            Token: _token,
            FixedRate: _fixedRate,
            CreditLine: _amount,
            Amount:0,
            isCancel: false
        }));
        // save borrower info
        Borrower[]  storage borrowerInfo = BorrowerData[_approveAddress][msg.sender];
        borrowerInfo.push(Borrower({
            Creditors: msg.sender,
            Token: _token,
            FixedRate: _fixedRate,
            CreditLine: _amount,
            Amount: 0,
            isCancel: false
        }));
        // log
        emit Trust(_approveAddress, _token, _fixedRate, _amount);
    }


    function RemoveTrust(address _approveAddress, uint256 _index, uint256 _cancelAmount) external nonReentrant whenNotPaused {
        require(_approveAddress != address(0), "approveAddress is not a zero address");
        require(_cancelAmount != 0, "The number of cancellations cannot be equal to 0");
        require(_approveAddress != msg.sender, "approveAddress is not msg.sender");
        require(LenderIsBool[msg.sender][_approveAddress], "lender is not approve approveAddress");

        Lender[]  storage lendInfo = LenderData[msg.sender][_approveAddress];
        uint256 lendInfoLength = lendInfo.length;
        require(_index <= lendInfoLength - 1, "Index Overrun");
        Lender storage personalLenderInfo = LenderData[msg.sender][_approveAddress][_index];


        Borrower[] storage borrowerInfo = BorrowerData[_approveAddress][msg.sender];
        uint256 borrowInfoLength = borrowerInfo.length;
        require(_index <= borrowInfoLength - 1, "borrower index Overrun");
        Borrower storage personalBorrowerInfo = BorrowerData[_approveAddress][msg.sender][_index];

        require(!personalLenderInfo.isCancel, "The authorization id record has been cancelled");
        // Number of Cancellations <= Number of Trusts - Number of Lending
        require(_cancelAmount <= personalLenderInfo.CreditLine - personalBorrowerInfo.Amount , "The number of cancellations cannot be greater than the number of authorizations");

        if (_cancelAmount == personalLenderInfo.CreditLine) {
            // Complete cancellation
            personalLenderInfo.isCancel = !personalLenderInfo.isCancel;
            personalBorrowerInfo.isCancel = !personalBorrowerInfo.isCancel;
            personalLenderInfo.CreditLine = personalLenderInfo.CreditLine - _cancelAmount;
            personalBorrowerInfo.CreditLine = personalBorrowerInfo.CreditLine - _cancelAmount;
        } else {
            // Partial cancellation of authorization
            personalLenderInfo.CreditLine = personalLenderInfo.CreditLine - _cancelAmount;
            personalBorrowerInfo.CreditLine = personalBorrowerInfo.CreditLine - _cancelAmount;
        }
        // log
        emit ReduceTrust(_approveAddress, _index,  _cancelAmount);
    }


    function Withdrawal(address _lendAddress, uint256 _index, uint256 _borrowerAmount) external nonReentrant whenNotPaused {

        require(_lendAddress != address(0), "_lendAddress is not a zero address");
        require(_lendAddress != msg.sender, "lendAddress is not msg.sender");
        require(_borrowerAmount != 0, "The number of borrower amount cannot be equal to 0");
        require(BorrowerIsBool[msg.sender][_lendAddress], "lender is not approve msg.sender");

        Borrower[] storage borrowerInfo = BorrowerData[msg.sender][_lendAddress];
        uint256 borrowerInfoLength = borrowerInfo.length;
        require(_index <= borrowerInfoLength - 1, "Index Overrun");
        Borrower storage personalBorrowerInfo = BorrowerData[msg.sender][_lendAddress][_index];

        require(!personalBorrowerInfo.isCancel, "The authorization id record has been cancelled");

        // Current number of remaining loans = number of credits - number already lent
        require(_borrowerAmount <= personalBorrowerInfo.CreditLine - personalBorrowerInfo.Amount, "The number of withdrawals must be less than or equal to the effective number");
        // Determine if lend's current balance is available for borrowing
        uint256 lenderBalance = IERC20(personalBorrowerInfo.Token).balanceOf(personalBorrowerInfo.Creditors);
        require(_borrowerAmount <= lenderBalance, "The lend balance is less than the borrowable quantity");

        // save borrower info
        personalBorrowerInfo.Amount = personalBorrowerInfo.Amount + _borrowerAmount;

        // save data
        Lender[]  storage lendInfo = LenderData[_lendAddress][msg.sender];
        uint256 lendInfoLength = lendInfo.length;
        require(_index <= lendInfoLength - 1, "Index Overrun");

        Lender storage personalLenderInfo = LenderData[_lendAddress][msg.sender][_index];
        personalLenderInfo.Amount = personalLenderInfo.Amount + _borrowerAmount;

        //Total number of borrowers, statistics of fees charged by the platform
        if (!isTotalBorrower[msg.sender]) {
            totalBorrower.push(msg.sender);
            isTotalBorrower[msg.sender] = !isTotalBorrower[msg.sender];

            if (!BorrowerBool[msg.sender][_lendAddress]) {
                BorrowerArrary[msg.sender].push(_lendAddress);
                BorrowerBool[msg.sender][_lendAddress]= !BorrowerBool[msg.sender][_lendAddress];
            }

            if (!TotalBorrowerBool[msg.sender][_lendAddress][_index]){
                TotalBorrowerIndexArrary[msg.sender][_lendAddress].push(_index);
                TotalBorrowerBool[msg.sender][_lendAddress][_index] = !TotalBorrowerBool[msg.sender][_lendAddress][_index];
            }

        }
        // borrow token
        uint256 amount = getPayableAmount(personalBorrowerInfo.Token, personalBorrowerInfo.Creditors, msg.sender, _borrowerAmount);
        require(amount == _borrowerAmount, "The actual money lent is not the same as the money needed to be borrowed");

        // check if token address equal to BUSD token address
        if (personalBorrowerInfo.Token == 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee) {
            uint buddyDaoTokenPrice = getTokenPrice(_borrowerAmount);

            // Check if the borrower has enough BuddyDaoToken balance to pay the service fee
            uint serviceFeeInBuddyDao = (_borrowerAmount * ServiceFee * buddyDaoTokenPrice) / 1e36;
            uint borrowerBuddyDaoBalance = IERC20(0x84E13D8aA38a8230DB2dAe46A6555a5DEec532e6).balanceOf(msg.sender);
            if (borrowerBuddyDaoBalance >= serviceFeeInBuddyDao) {
                // Transfer the service fee in BuddyDaoToken to the service fee address
                IERC20(0x84E13D8aA38a8230DB2dAe46A6555a5DEec532e6).transferFrom(msg.sender, ServiceFeeAddress, serviceFeeInBuddyDao);
            } else {
                // Transfer the service fee in BUSD to the service fee address
                uint serviceFeeInBusd = (_borrowerAmount * ServiceFee) / 1e18;
                IERC20(personalBorrowerInfo.Token).transferFrom(msg.sender, ServiceFeeAddress, serviceFeeInBusd);
            }
            // Subtract the service fee from the borrower's withdrawal amount in BUSD
            _borrowerAmount -= (_borrowerAmount * ServiceFee) / 1e18;
        } else {
            // When the token is not BUSD, transfer the service fee in the token to the service fee address
            uint256 serviceFee = (_borrowerAmount * ServiceFee) / 1e18;
            IERC20(personalBorrowerInfo.Token).transferFrom(msg.sender, ServiceFeeAddress, serviceFee);
            // Subtract the service fee from the borrower's withdrawal amount
            _borrowerAmount -= serviceFee;
        }
        // log
        emit WithdrawAssets(_lendAddress, _index, _borrowerAmount);
    }

    function getTokenPrice(uint amount) public view returns (uint) {
        IPancakePair pair = IPancakePair(0x57ae7f7700542d33184Ae5B8E879074ec77acbb2);
        IERC20 token1 = IERC20(pair.token1());
        (uint Res0, uint Res1,) = pair.getReserves();

        // decimals
        uint res0 = Res0 * (10**token1.decimals());
        return (amount * res0) / Res1 / (10**token1.decimals()); // return amount of token0 needed to buy token1 (as a whole number)
    }


    function Pay(address _lendAddress, uint256 _index, uint256 _payAmount) external nonReentrant whenNotPaused {
        require(_lendAddress != address(0), "_lendAddress is not a zero address");
        require(_lendAddress != msg.sender, "lendAddress is not msg.sender");
        require(_payAmount != 0, "The number of payment amount cannot be equal to 0");
        require(BorrowerIsBool[msg.sender][_lendAddress], "lender is not approve msg.sender");

        Borrower[] storage borrowerInfo = BorrowerData[msg.sender][_lendAddress];
        uint256 borrowerInfoLength = borrowerInfo.length;
        require(_index <= borrowerInfoLength - 1, "Index Overrun");

        // Compare the number of returns
        Borrower storage personalBorrowerInfo = BorrowerData[msg.sender][_lendAddress][_index];

        // todo:The v1 version is required to calculate interest, the v2 version is not
        // uint256 borrowerInterest = calculatingInterest(_lendAddress, msg.sender,  _index,  _payAmount);

        require(_payAmount <= personalBorrowerInfo.Amount, "The returned quantity must be less than or equal to the borrowed quantity.");
        // check allowance
        uint256 allowBalance = IERC20(personalBorrowerInfo.Token).allowance(msg.sender, address(this));
        require(_payAmount <= allowBalance, "borrower lack of allowance");

        // Calculate whether the user's balance is sufficient for return
        uint256 userBalance = IERC20(personalBorrowerInfo.Token).balanceOf(msg.sender);
        require(userBalance >= _payAmount, "Insufficient balance");
        // Actual quantity returned = Quantity + Interest
        //uint256 actualPay = _payAmount + borrowerInterest;

        // Payment
        uint256 amount = getPayableAmount(personalBorrowerInfo.Token, msg.sender, personalBorrowerInfo.Creditors, _payAmount);
        require(amount == _payAmount, "The actual amount and the deducted amount do not match");

        // save borrower info
        personalBorrowerInfo.Amount = personalBorrowerInfo.Amount - _payAmount;
        // save  lend info
        Lender[]  storage lendInfo = LenderData[_lendAddress][msg.sender];
        uint256 lendInfoLength = lendInfo.length;
        require(_index <= lendInfoLength - 1, "Index Overrun");

        Lender storage personalLenderInfo = LenderData[_lendAddress][msg.sender][_index];
        personalLenderInfo.Amount = personalLenderInfo.Amount - _payAmount;
        // log
        emit Payment(_lendAddress, _index, _payAmount);
    }


    function calculatingInterest(address _lendAddress, address _borrower, uint256 _index, uint256 _payAmount) public view returns(uint256){
        require(_lendAddress != address(0), "_lendAddress is not a zero address");
        require(_payAmount != 0, "The number of payment amount cannot be equal to 0");
        Borrower[] storage borrowerInfo = BorrowerData[_borrower][_lendAddress];
        uint256 borrowerInfoLength = borrowerInfo.length;
        require(_index <= borrowerInfoLength - 1, "Index Overrun");
        Borrower storage personalBorrowerInfo = BorrowerData[_borrower][_lendAddress][_index];
        // interest = Number of borrowing *  Daily Lending Rate
        uint256 dailyRate = personalBorrowerInfo.FixedRate.mul(baseDecimal).div(baseYearOrMonth).div(baseDecimal);
        uint256 dailyInterest = _payAmount.mul(dailyRate).div(baseDecimal);
        return dailyInterest;
    }

    // Calculation of the actual interest paid, taking into account the adequacy of the remaining assets in the account and the adequacy of the authorized amount
    function calculatingActualInterest(uint256 _balance, uint256 _allowBalance, uint256 _dailyRate) public pure returns(uint256){
        uint256 payAmount;
        if (_balance < _dailyRate){
           if (_balance < _allowBalance){
              payAmount = _balance;
           } else {
              payAmount = _allowBalance;
           }
        } else {
           if (_dailyRate < _allowBalance){
              payAmount = _dailyRate;
           } else {
              payAmount = _allowBalance;
           }
        }
        return payAmount;
    }

    // chainlink auto
    function checkUpkeep(bytes calldata) external view override whenNotPaused returns (bool upkeepNeeded, bytes memory){
        // Current time is greater than the time period
        if (block.timestamp > StartTimeInterval + TimeInterval) {
            upkeepNeeded = totalBorrower.length > 0;
        }
    }

    // chainlink logic
    function performUpkeep(bytes calldata) external override whenNotPaused {

        if (block.timestamp > StartTimeInterval + TimeInterval) {
            if (totalBorrower.length > 0) {
                for (uint256 i = 0; i < totalBorrower.length; i++){
                    // todo:一个borrower借贷的数组数据
                     address[] memory LendAddress = BorrowerArrary[totalBorrower[i]];
                     for (uint256 j = 0; j < LendAddress.length; j++) {
                         // Find borrower information
                         Borrower[] memory data = BorrowerData[totalBorrower[i]][LendAddress[j]];
                         if (data.length == 0) {
                             continue;
                         }
                         uint256[] memory BorrowerAddressIndex = TotalBorrowerIndexArrary[totalBorrower[i]][LendAddress[j]];
                         for (uint256 k = 0; k < BorrowerAddressIndex.length; k++) {
                              for (uint256 index = 0; index < data.length; index++){
                                  if (data[index].isCancel){
                                      continue;
                                  }
                                  if (data[index].Amount > 0 ){
                                      // Calculate daily interest = Current number of borrowings * Daily Rate
                                      uint256 dailyRate = calculatingInterest(LendAddress[j], totalBorrower[i], index, data[index].Amount);
                                      // uint256 fixedRate = (data[index].Amount.mul(ServiceFee)).div(baseDecimal);
                                      // Determine whether the lending user has sufficient balance to pay the fee
                                      uint256 borrowerBalance = IERC20(data[index].Token).balanceOf(totalBorrower[i]);
                                      if (borrowerBalance == 0 ){
                                          continue;
                                      }
                                      // check allowance
                                      uint256 allowBalance = IERC20(data[index].Token).allowance(totalBorrower[i], address(this));
                                      if (allowBalance == 0){
                                          continue;
                                      }
                                      uint256 rateAmount = calculatingActualInterest(borrowerBalance, allowBalance, dailyRate);
                                      // payment fee
                                      uint256 amount = getPayableAmount(data[index].Token, totalBorrower[i], LendAddress[j], rateAmount);
                                      require(amount == rateAmount, "The actual amount and the deducted amount do not match");
                                  }
                              }
                           }

                         }
                     }
            }
            // Update the starting point of the current time period
            StartTimeInterval = block.timestamp;
        }
    }

}