#!/bin/sh
 #                                                                                                                                    
# +-+-+-+-+-+-+-+-+-+-+-+-+
# welcometo1984.com|
# +-+-+-+-+-+-+-+-+-+-+-+-+
#
# /\_/\
#((@v@))
#():::()
# VV-VV
#

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#

echo "FYI: This will kick you off and reboot the router."
echo "Wait for it to reboot and you'll be back."
echo "You may need to unplug the ethernet cable and plug it back in."

rm /tmp/dhcp.leases

reboot

exit 0
