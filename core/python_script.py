# file: node3d.py
from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3
from py4godot.constants.constants import VECTOR3_UP
from py4godot.classes.Node3D.Node3D import Node3D

import torch

@gdclass
class node3d(Node3D):


	def _ready(self) -> None:
		pass
		# put initialization code here
