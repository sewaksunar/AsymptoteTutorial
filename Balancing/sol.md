Dimensional synthesis of planar mechanisms is the process of determining the detailed dimensions of individual links, such as lengths and pivot locations, to achieve a specific motion requirement. This process follows type synthesis (choosing the kind of mechanism) and number synthesis (finding the appropriate number of links and joints). In planar linkages, dimensional synthesis is primarily categorized into three classes: **function generation**, where the mechanism's output is coordinated with its input according to a specified mathematical relationship; **path generation**, where a coupler point is required to follow a prescribed trajectory; and **body guidance**, where a rigid body is moved through a series of specific postures. Because it is often impossible to satisfy a desired motion exactly over an entire range, designers utilize **precision postures** (accuracy points) where the requirements are met exactly, assuming the theoretical **structural error** between these points remains within acceptable limits. **Freudenstein’s equation** is a primary analytical tool for function generation, providing a mathematical model that relates link lengths to the input and output angles at these precision points.

### **Synthesis of the Four-Bar Linkage**

The objective is to synthesize a linkage to generate the function $y = x^{1.8}$ for $1 \le x \le 5$ using three precision points at $x = 1, 3,$ and $5$.

#### **1. Mapping Variables to Angles**
First, we determine the corresponding $y$ values and map the $x$ and $y$ ranges to the specified input ( $\theta$ ) and output ($\phi$) ranges.
*   **Range of $x$:** $1 \le x \le 5$, where $\Delta x = 4$.
*   **Range of $y$:** $[1^{1.8}, 5^{1.8}] = [1, 18.1195]$, where $\Delta y = 17.1195$.
*   **Input $\theta$:** Starts at $\theta_S = 30^\circ$, range $90^\circ$ ($\theta \in [30^\circ, 120^\circ]$).
*   **Output $\phi$:** Starts at $\phi_S = 0^\circ$, range $90^\circ$ ($\phi \in [0^\circ, 90^\circ]$).

**Calculated Values at Accuracy Points:**
| Accuracy Point | $x$ | $y = x^{1.8}$ | $\theta = 30^\circ + \frac{x-1}{4} \times 90^\circ$ | $\phi = 0^\circ + \frac{y-1}{17.1195} \times 90^\circ$ |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | 1 | **$30^\circ$** | **$0^\circ$** |
| 2 | 3 | 7.2247 | **$75^\circ$** | **$32.723^\circ$** |
| 3 | 5 | 18.1195 | **$120^\circ$** | **$90^\circ$** |

#### **2. Freudenstein's Equation Formulation**
Freudenstein’s equation is defined as:
$K_1 \cos\theta + K_2 \cos\phi + K_3 = \cos(\theta - \phi)$.
Substituting the three precision postures into this equation gives the following system of three linear equations:
1.  $K_1 \cos(30^\circ) + K_2 \cos(0^\circ) + K_3 = \cos(30^\circ - 0^\circ)$
2.  $K_1 \cos(75^\circ) + K_2 \cos(32.723^\circ) + K_3 = \cos(75^\circ - 32.723^\circ)$
3.  $K_1 \cos(120^\circ) + K_2 \cos(90^\circ) + K_3 = \cos(120^\circ - 90^\circ)$

#### **3. Solving for Constants**
The numerical representation of the equations is:
1.  $0.8660 K_1 + 1.0000 K_2 + K_3 = 0.8660$
2.  $0.2588 K_1 + 0.8413 K_2 + K_3 = 0.7399$
3.  $-0.5000 K_1 + 0.0000 K_2 + K_3 = 0.8660$

From Equation (3), we find: $K_3 = 0.8660 + 0.5 K_1$.
Substituting $K_3$ into Equation (1): $1.3660 K_1 + K_2 = 0 \implies K_2 = -1.3660 K_1$.
Substituting both into Equation (2):
$0.2588 K_1 + 0.8413(-1.3660 K_1) + 0.8660 + 0.5 K_1 = 0.7399$
$-0.3904 K_1 = -0.1261 \implies \mathbf{K_1 = 0.3230}$.
Using back-substitution: $\mathbf{K_2 = -0.4412}$ and $\mathbf{K_3 = 1.0275}$.

#### **4. Determination of Link Lengths**
The constants are related to the link lengths ($r_1$ fixed, $r_2$ crank, $r_3$ coupler, $r_4$ rocker) as follows:
*   $K_1 = r_1 / r_4 \implies r_4 = r_1 / K_1$
*   $K_2 = r_1 / r_2 \implies r_2 = r_1 / K_2$
*   $K_3 = (r_3^2 - r_1^2 - r_2^2 - r_4^2) / (2 r_2 r_4)$

Assuming the fixed link length **$r_1 = 100$ units**:
*   Rocker length **$r_4 = 100 / 0.3230 \approx 309.6$ units**.
*   Crank length **$r_2 = 100 / -0.4412 \approx -226.7$ units**. (The negative sign indicates a crossed-linkage configuration).
*   Coupler length **$r_3$**:
    $1.0275 = (r_3^2 - 100^2 - (-226.7)^2 - 309.6^2) / (2 \times -226.7 \times 309.6)$
    $1.0275 = (r_3^2 - 157245.5) / (-140371.2)$
    $-144231.4 = r_3^2 - 157245.5$
    $r_3^2 = 13014.1 \implies \mathbf{r_3 \approx 114.1 \text{ units}}$.

**Final Result:**
The synthesized four-bar linkage has link lengths of **$r_1 = 100, r_2 = 226.7, r_3 = 114.1,$ and $r_4 = 309.6$**. The linkage will exactly generate $y = x^{1.8}$ at the precision points $x = 1, 3,$ and $5$ within the specified angular ranges.