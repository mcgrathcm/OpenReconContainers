# bios214radial 0.1.2

Fixed 2D radial reconstruction for BIOS 214. Research use.

- Input: ISMRMRD raw coil data over TCP 9002. Each image requires 202 spokes with 128 samples per spoke and LIN 0 through 201. The trajectory is bundled in the image.
- Output: 128 x 128 Float32 magnitude image, scaled to 0-4095. MRD dimensions (channel,z,y,x): (1,1,128,128). FOV: (256,256,10) mm.
- Resources: one CPU core, 4 GB RAM; no GPU required.

Scanner installation: install the ZIP through OpenRecon, select
bios214radial for the Pulseq protocol and disable Prio Recon.
