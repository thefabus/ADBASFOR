from .general import NOUT
from .call import call_BASFOR_C, call_dBASFOR_C, submit

import torch
import torch.nn as nn
import numpy as np

@torch.library.custom_op("adbasfor::adbasfor", mutates_args=[], device_types="cpu")
def adbasfor_op(params: torch.Tensor, matrix_weather: torch.Tensor, calendar_fert: torch.Tensor, calendar_Ndep: torch.Tensor, calendar_prunT: torch.Tensor, calendar_thinT: torch.Tensor, ndays: torch.Tensor) -> torch.Tensor:
    device = params.device
    output = call_BASFOR_C(
        params.cpu().numpy(),
        matrix_weather.cpu().numpy(),
        calendar_fert.cpu().numpy(),
        calendar_Ndep.cpu().numpy(),
        calendar_prunT.cpu().numpy(),
        calendar_thinT.cpu().numpy(),
        ndays.cpu().item()
    )
    return torch.from_numpy(output).to(device)

"""
@adbasfor_op.register_fake
def _(params: torch.Tensor, *args) -> torch.Tensor:
    return params.new_empty((NDAYS, NOUT))
"""

def backward(ctx, grad_output):
    saved = ctx.saved_tensors

    saved = [x.detach().numpy() for x in saved]
    saved[-1] = int(saved[-1]) # ndays
    
    grad_input = list(call_dBASFOR_C(*saved, y=grad_output.cpu().detach().numpy()))

    grad_input[0] = grad_input[0][:saved[0].size] # params
    grad_input = [torch.from_numpy(x) for x in grad_input]
    grad_input += [None] # ndays

    return tuple(grad_input)

def setup_context(ctx, inputs, output):
    ctx.save_for_backward(*inputs)

adbasfor_op.register_autograd(backward, setup_context=setup_context)

class ADBASFOR(nn.Module):
    def __init__(self):
        super().__init__()
    
    def forward(self, *args, **kwargs):
        return adbasfor_op(*args, **kwargs)
