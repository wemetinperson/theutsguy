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

echo "Please wait while command completes..."

opkg update

sleep 5s


if [ "$(opkg list-upgradable)" == "" ]
then
  echo "No Updates Needed."
  exit 0
fi

opkg upgrade $(opkg list-upgradable | awk '{print $1}')

echo "Update complete!"

exit 0
