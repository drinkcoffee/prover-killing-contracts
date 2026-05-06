using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Numerics;
using Nethereum.Hex.HexTypes;
using Nethereum.ABI.FunctionEncoding.Attributes;
using Nethereum.RPC.Eth.DTOs;
using Nethereum.Contracts.CQS;
using Nethereum.Contracts;
using System.Threading;
using LoadTest.Storage4.ContractDefinition;

namespace LoadTest.Storage4.ContractDefinition
{


    public partial class Storage4Deployment : Storage4DeploymentBase
    {
        public Storage4Deployment() : base(BYTECODE) { }
        public Storage4Deployment(string byteCode) : base(byteCode) { }
    }

    public class Storage4DeploymentBase : ContractDeploymentMessage
    {
        public static string BYTECODE = "0x608060405234801561000f575f80fd5b506102988061001d5f395ff3fe608060405234801561000f575f80fd5b506004361061004a575f3560e01c80633ddc348e1461004e5780637d36855d1461006c578063e4d9448b1461008a578063f1b693c3146100a6575b5f80fd5b6100566100b0565b6040516100639190610149565b60405180910390f35b6100746100b8565b6040516100819190610149565b60405180910390f35b6100a4600480360381019061009f9190610190565b6100be565b005b6100ae6100c7565b005b5f8054905090565b60025481565b805f8190555050565b5f60025490505f5b6103e8811015610119576001816100e691906101e8565b60015f83856100f591906101e8565b81526020019081526020015f208190555080806101119061021b565b9150506100cf565b506103e88161012891906101e8565b60028190555050565b5f819050919050565b61014381610131565b82525050565b5f60208201905061015c5f83018461013a565b92915050565b5f80fd5b61016f81610131565b8114610179575f80fd5b50565b5f8135905061018a81610166565b92915050565b5f602082840312156101a5576101a4610162565b5b5f6101b28482850161017c565b91505092915050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f6101f282610131565b91506101fd83610131565b9250828201905080821115610215576102146101bb565b5b92915050565b5f61022582610131565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8203610257576102566101bb565b5b60018201905091905056fea26469706673582212207185cb55a6c9391f18ed5507e5f0e20d3da83c8af4e141f0c85a9a91b698f7fe64736f6c63430008140033";
        public Storage4DeploymentBase() : base(BYTECODE) { }
        public Storage4DeploymentBase(string byteCode) : base(byteCode) { }

    }

    public partial class FillOfsFunction : FillOfsFunctionBase { }

    [Function("fillOfs", "uint256")]
    public class FillOfsFunctionBase : FunctionMessage
    {

    }

    public partial class FillUpStorageFunction : FillUpStorageFunctionBase { }

    [Function("fillUpStorage")]
    public class FillUpStorageFunctionBase : FunctionMessage
    {

    }

    public partial class LoadColdFunction : LoadColdFunctionBase { }

    [Function("loadCold", "uint256")]
    public class LoadColdFunctionBase : FunctionMessage
    {

    }

    public partial class StoreColdFunction : StoreColdFunctionBase { }

    [Function("storeCold")]
    public class StoreColdFunctionBase : FunctionMessage
    {
        [Parameter("uint256", "_val", 1)]
        public virtual BigInteger Val { get; set; }
    }

    public partial class FillOfsOutputDTO : FillOfsOutputDTOBase { }

    [FunctionOutput]
    public class FillOfsOutputDTOBase : IFunctionOutputDTO 
    {
        [Parameter("uint256", "", 1)]
        public virtual BigInteger ReturnValue1 { get; set; }
    }



    public partial class LoadColdOutputDTO : LoadColdOutputDTOBase { }

    [FunctionOutput]
    public class LoadColdOutputDTOBase : IFunctionOutputDTO 
    {
        [Parameter("uint256", "", 1)]
        public virtual BigInteger ReturnValue1 { get; set; }
    }


}
