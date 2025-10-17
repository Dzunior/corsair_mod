// Created with Corsair vgit-latest
#ifndef __REGS_H
#define __REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define CSR_BASE_ADDR 0x80080000

// CONFIG - Global configuration register
#define CSR_CONFIG_ADDR 0x0
#define CSR_CONFIG_RESET 0x50000100
typedef struct {
    uint32_t MODE : 3; // Operating mode selection
    uint32_t : 1; // reserved
    uint32_t ENABLE : 1; // Global enable bit
    uint32_t RESERVED : 3; // Reserved bits (constant 0)
    uint32_t CLK_DIV : 8; // Clock divider ratio
    uint32_t : 12; // reserved
    uint32_t ARCH_ID : 4; // Architecture identifier (constant)
} csr_config_t;

// CONFIG.MODE - Operating mode selection
#define CSR_CONFIG_MODE_WIDTH 3
#define CSR_CONFIG_MODE_LSB 0
#define CSR_CONFIG_MODE_MASK 0x7
#define CSR_CONFIG_MODE_RESET 0x0
typedef enum {
    CSR_CONFIG_MODE_BYPASS = 0x0, //Bypass mode
    CSR_CONFIG_MODE_FILTER_LP = 0x1, //Low-pass filter
    CSR_CONFIG_MODE_FILTER_HP = 0x2, //High-pass filter
    CSR_CONFIG_MODE_FILTER_BP = 0x3, //Band-pass filter
} csr_config_mode_t;

// CONFIG.ENABLE - Global enable bit
#define CSR_CONFIG_ENABLE_WIDTH 1
#define CSR_CONFIG_ENABLE_LSB 4
#define CSR_CONFIG_ENABLE_MASK 0x10
#define CSR_CONFIG_ENABLE_RESET 0x0

// CONFIG.RESERVED - Reserved bits (constant 0)
#define CSR_CONFIG_RESERVED_WIDTH 3
#define CSR_CONFIG_RESERVED_LSB 5
#define CSR_CONFIG_RESERVED_MASK 0xe0
#define CSR_CONFIG_RESERVED_RESET 0x0

// CONFIG.CLK_DIV - Clock divider ratio
#define CSR_CONFIG_CLK_DIV_WIDTH 8
#define CSR_CONFIG_CLK_DIV_LSB 8
#define CSR_CONFIG_CLK_DIV_MASK 0xff00
#define CSR_CONFIG_CLK_DIV_RESET 0x1

// CONFIG.ARCH_ID - Architecture identifier (constant)
#define CSR_CONFIG_ARCH_ID_WIDTH 4
#define CSR_CONFIG_ARCH_ID_LSB 28
#define CSR_CONFIG_ARCH_ID_MASK 0xf0000000
#define CSR_CONFIG_ARCH_ID_RESET 0x5

// STATUS - System status register
#define CSR_STATUS_ADDR 0x4
#define CSR_STATUS_RESET 0x0
typedef struct {
    uint32_t READY : 1; // System ready flag
    uint32_t OVERFLOW : 1; // Data overflow flag. Read to clear.
    uint32_t UNDERFLOW : 1; // Data underflow flag. Read to clear.
    uint32_t : 1; // reserved
    uint32_t PROCESSING : 1; // Processing in progress
    uint32_t : 11; // reserved
    uint32_t FIFO_LEVEL : 10; // Current FIFO fill level
    uint32_t : 6; // reserved
} csr_status_t;

// STATUS.READY - System ready flag
#define CSR_STATUS_READY_WIDTH 1
#define CSR_STATUS_READY_LSB 0
#define CSR_STATUS_READY_MASK 0x1
#define CSR_STATUS_READY_RESET 0x0

// STATUS.OVERFLOW - Data overflow flag. Read to clear.
#define CSR_STATUS_OVERFLOW_WIDTH 1
#define CSR_STATUS_OVERFLOW_LSB 1
#define CSR_STATUS_OVERFLOW_MASK 0x2
#define CSR_STATUS_OVERFLOW_RESET 0x0

// STATUS.UNDERFLOW - Data underflow flag. Read to clear.
#define CSR_STATUS_UNDERFLOW_WIDTH 1
#define CSR_STATUS_UNDERFLOW_LSB 2
#define CSR_STATUS_UNDERFLOW_MASK 0x4
#define CSR_STATUS_UNDERFLOW_RESET 0x0

// STATUS.PROCESSING - Processing in progress
#define CSR_STATUS_PROCESSING_WIDTH 1
#define CSR_STATUS_PROCESSING_LSB 4
#define CSR_STATUS_PROCESSING_MASK 0x10
#define CSR_STATUS_PROCESSING_RESET 0x0

// STATUS.FIFO_LEVEL - Current FIFO fill level
#define CSR_STATUS_FIFO_LEVEL_WIDTH 10
#define CSR_STATUS_FIFO_LEVEL_LSB 16
#define CSR_STATUS_FIFO_LEVEL_MASK 0x3ff0000
#define CSR_STATUS_FIFO_LEVEL_RESET 0x0

// CONTROL - System control register
#define CSR_CONTROL_ADDR 0x8
#define CSR_CONTROL_RESET 0x0
typedef struct {
    uint32_t START : 1; // Start processing (self-clearing)
    uint32_t STOP : 1; // Stop processing (self-clearing)
    uint32_t RESET_FIFO : 1; // Reset FIFO (self-clearing)
    uint32_t : 5; // reserved
    uint32_t AUTO_RESTART : 1; // Enable automatic restart on completion
    uint32_t DEBUG_EN : 1; // Enable debug mode
    uint32_t : 22; // reserved
} csr_control_t;

// CONTROL.START - Start processing (self-clearing)
#define CSR_CONTROL_START_WIDTH 1
#define CSR_CONTROL_START_LSB 0
#define CSR_CONTROL_START_MASK 0x1
#define CSR_CONTROL_START_RESET 0x0

// CONTROL.STOP - Stop processing (self-clearing)
#define CSR_CONTROL_STOP_WIDTH 1
#define CSR_CONTROL_STOP_LSB 1
#define CSR_CONTROL_STOP_MASK 0x2
#define CSR_CONTROL_STOP_RESET 0x0

// CONTROL.RESET_FIFO - Reset FIFO (self-clearing)
#define CSR_CONTROL_RESET_FIFO_WIDTH 1
#define CSR_CONTROL_RESET_FIFO_LSB 2
#define CSR_CONTROL_RESET_FIFO_MASK 0x4
#define CSR_CONTROL_RESET_FIFO_RESET 0x0

// CONTROL.AUTO_RESTART - Enable automatic restart on completion
#define CSR_CONTROL_AUTO_RESTART_WIDTH 1
#define CSR_CONTROL_AUTO_RESTART_LSB 8
#define CSR_CONTROL_AUTO_RESTART_MASK 0x100
#define CSR_CONTROL_AUTO_RESTART_RESET 0x0

// CONTROL.DEBUG_EN - Enable debug mode
#define CSR_CONTROL_DEBUG_EN_WIDTH 1
#define CSR_CONTROL_DEBUG_EN_LSB 9
#define CSR_CONTROL_DEBUG_EN_MASK 0x200
#define CSR_CONTROL_DEBUG_EN_RESET 0x0

// THRESHOLD - Threshold configuration register
#define CSR_THRESHOLD_ADDR 0xc
#define CSR_THRESHOLD_RESET 0xf9b0064
typedef struct {
    uint32_t LOW_THRESH : 16; // Lower threshold value
    uint32_t HIGH_THRESH : 16; // Upper threshold value
} csr_threshold_t;

// THRESHOLD.LOW_THRESH - Lower threshold value
#define CSR_THRESHOLD_LOW_THRESH_WIDTH 16
#define CSR_THRESHOLD_LOW_THRESH_LSB 0
#define CSR_THRESHOLD_LOW_THRESH_MASK 0xffff
#define CSR_THRESHOLD_LOW_THRESH_RESET 0x64

// THRESHOLD.HIGH_THRESH - Upper threshold value
#define CSR_THRESHOLD_HIGH_THRESH_WIDTH 16
#define CSR_THRESHOLD_HIGH_THRESH_LSB 16
#define CSR_THRESHOLD_HIGH_THRESH_MASK 0xffff0000
#define CSR_THRESHOLD_HIGH_THRESH_RESET 0xf9b

// GAIN - Gain control register
#define CSR_GAIN_ADDR 0x10
#define CSR_GAIN_RESET 0x20800
typedef struct {
    uint32_t COARSE_GAIN : 4; // Coarse gain control (dB steps)
    uint32_t FINE_GAIN : 8; // Fine gain adjustment
    uint32_t : 4; // reserved
    uint32_t GAIN_FORMAT : 2; // Gain format indicator (constant)
    uint32_t : 13; // reserved
    uint32_t AGC_EN : 1; // Automatic gain control enable
} csr_gain_t;

// GAIN.COARSE_GAIN - Coarse gain control (dB steps)
#define CSR_GAIN_COARSE_GAIN_WIDTH 4
#define CSR_GAIN_COARSE_GAIN_LSB 0
#define CSR_GAIN_COARSE_GAIN_MASK 0xf
#define CSR_GAIN_COARSE_GAIN_RESET 0x0

// GAIN.FINE_GAIN - Fine gain adjustment
#define CSR_GAIN_FINE_GAIN_WIDTH 8
#define CSR_GAIN_FINE_GAIN_LSB 4
#define CSR_GAIN_FINE_GAIN_MASK 0xff0
#define CSR_GAIN_FINE_GAIN_RESET 0x80

// GAIN.GAIN_FORMAT - Gain format indicator (constant)
#define CSR_GAIN_GAIN_FORMAT_WIDTH 2
#define CSR_GAIN_GAIN_FORMAT_LSB 16
#define CSR_GAIN_GAIN_FORMAT_MASK 0x30000
#define CSR_GAIN_GAIN_FORMAT_RESET 0x2
typedef enum {
    CSR_GAIN_GAIN_FORMAT_LINEAR = 0x0, //Linear gain format
    CSR_GAIN_GAIN_FORMAT_LOG = 0x1, //Logarithmic gain format
    CSR_GAIN_GAIN_FORMAT_FIXED_POINT = 0x2, //Fixed-point Q8.8 format
} csr_gain_gain_format_t;

// GAIN.AGC_EN - Automatic gain control enable
#define CSR_GAIN_AGC_EN_WIDTH 1
#define CSR_GAIN_AGC_EN_LSB 31
#define CSR_GAIN_AGC_EN_MASK 0x80000000
#define CSR_GAIN_AGC_EN_RESET 0x0

// INT_MASK - Interrupt mask register
#define CSR_INT_MASK_ADDR 0x14
#define CSR_INT_MASK_RESET 0x0
typedef struct {
    uint32_t DONE_MASK : 1; // Mask processing done interrupt
    uint32_t ERROR_MASK : 1; // Mask error interrupt
    uint32_t OVERFLOW_MASK : 1; // Mask overflow interrupt
    uint32_t UNDERFLOW_MASK : 1; // Mask underflow interrupt
    uint32_t THRESHOLD_MASK : 1; // Mask threshold crossed interrupt
    uint32_t : 27; // reserved
} csr_int_mask_t;

// INT_MASK.DONE_MASK - Mask processing done interrupt
#define CSR_INT_MASK_DONE_MASK_WIDTH 1
#define CSR_INT_MASK_DONE_MASK_LSB 0
#define CSR_INT_MASK_DONE_MASK_MASK 0x1
#define CSR_INT_MASK_DONE_MASK_RESET 0x0

// INT_MASK.ERROR_MASK - Mask error interrupt
#define CSR_INT_MASK_ERROR_MASK_WIDTH 1
#define CSR_INT_MASK_ERROR_MASK_LSB 1
#define CSR_INT_MASK_ERROR_MASK_MASK 0x2
#define CSR_INT_MASK_ERROR_MASK_RESET 0x0

// INT_MASK.OVERFLOW_MASK - Mask overflow interrupt
#define CSR_INT_MASK_OVERFLOW_MASK_WIDTH 1
#define CSR_INT_MASK_OVERFLOW_MASK_LSB 2
#define CSR_INT_MASK_OVERFLOW_MASK_MASK 0x4
#define CSR_INT_MASK_OVERFLOW_MASK_RESET 0x0

// INT_MASK.UNDERFLOW_MASK - Mask underflow interrupt
#define CSR_INT_MASK_UNDERFLOW_MASK_WIDTH 1
#define CSR_INT_MASK_UNDERFLOW_MASK_LSB 3
#define CSR_INT_MASK_UNDERFLOW_MASK_MASK 0x8
#define CSR_INT_MASK_UNDERFLOW_MASK_RESET 0x0

// INT_MASK.THRESHOLD_MASK - Mask threshold crossed interrupt
#define CSR_INT_MASK_THRESHOLD_MASK_WIDTH 1
#define CSR_INT_MASK_THRESHOLD_MASK_LSB 4
#define CSR_INT_MASK_THRESHOLD_MASK_MASK 0x10
#define CSR_INT_MASK_THRESHOLD_MASK_RESET 0x0

// INT_STATUS - Interrupt status register
#define CSR_INT_STATUS_ADDR 0x18
#define CSR_INT_STATUS_RESET 0x0
typedef struct {
    uint32_t DONE_INT : 1; // Processing done interrupt. Write 1 to clear.
    uint32_t ERROR_INT : 1; // Error interrupt. Write 1 to clear.
    uint32_t OVERFLOW_INT : 1; // Overflow interrupt. Write 1 to clear.
    uint32_t UNDERFLOW_INT : 1; // Underflow interrupt. Write 1 to clear.
    uint32_t THRESHOLD_INT : 1; // Threshold crossed interrupt. Write 1 to clear.
    uint32_t : 27; // reserved
} csr_int_status_t;

// INT_STATUS.DONE_INT - Processing done interrupt. Write 1 to clear.
#define CSR_INT_STATUS_DONE_INT_WIDTH 1
#define CSR_INT_STATUS_DONE_INT_LSB 0
#define CSR_INT_STATUS_DONE_INT_MASK 0x1
#define CSR_INT_STATUS_DONE_INT_RESET 0x0

// INT_STATUS.ERROR_INT - Error interrupt. Write 1 to clear.
#define CSR_INT_STATUS_ERROR_INT_WIDTH 1
#define CSR_INT_STATUS_ERROR_INT_LSB 1
#define CSR_INT_STATUS_ERROR_INT_MASK 0x2
#define CSR_INT_STATUS_ERROR_INT_RESET 0x0

// INT_STATUS.OVERFLOW_INT - Overflow interrupt. Write 1 to clear.
#define CSR_INT_STATUS_OVERFLOW_INT_WIDTH 1
#define CSR_INT_STATUS_OVERFLOW_INT_LSB 2
#define CSR_INT_STATUS_OVERFLOW_INT_MASK 0x4
#define CSR_INT_STATUS_OVERFLOW_INT_RESET 0x0

// INT_STATUS.UNDERFLOW_INT - Underflow interrupt. Write 1 to clear.
#define CSR_INT_STATUS_UNDERFLOW_INT_WIDTH 1
#define CSR_INT_STATUS_UNDERFLOW_INT_LSB 3
#define CSR_INT_STATUS_UNDERFLOW_INT_MASK 0x8
#define CSR_INT_STATUS_UNDERFLOW_INT_RESET 0x0

// INT_STATUS.THRESHOLD_INT - Threshold crossed interrupt. Write 1 to clear.
#define CSR_INT_STATUS_THRESHOLD_INT_WIDTH 1
#define CSR_INT_STATUS_THRESHOLD_INT_LSB 4
#define CSR_INT_STATUS_THRESHOLD_INT_MASK 0x10
#define CSR_INT_STATUS_THRESHOLD_INT_RESET 0x0

// VERSION - Version and identification register
#define CSR_VERSION_ADDR 0x1c
#define CSR_VERSION_RESET 0xbbbb0203
typedef struct {
    uint32_t MINOR : 8; // Minor version number
    uint32_t MAJOR : 8; // Major version number
    uint32_t CORE_ID : 16; // IP core identifier
} csr_version_t;

// VERSION.MINOR - Minor version number
#define CSR_VERSION_MINOR_WIDTH 8
#define CSR_VERSION_MINOR_LSB 0
#define CSR_VERSION_MINOR_MASK 0xff
#define CSR_VERSION_MINOR_RESET 0x3

// VERSION.MAJOR - Major version number
#define CSR_VERSION_MAJOR_WIDTH 8
#define CSR_VERSION_MAJOR_LSB 8
#define CSR_VERSION_MAJOR_MASK 0xff00
#define CSR_VERSION_MAJOR_RESET 0x2

// VERSION.CORE_ID - IP core identifier
#define CSR_VERSION_CORE_ID_WIDTH 16
#define CSR_VERSION_CORE_ID_LSB 16
#define CSR_VERSION_CORE_ID_MASK 0xffff0000
#define CSR_VERSION_CORE_ID_RESET 0xbbbb


// Register map structure
typedef struct {
    union {
        __IO uint32_t CONFIG; // Global configuration register
        __IO csr_config_t CONFIG_bf; // Bit access for CONFIG register
    };
    union {
        __IO uint32_t STATUS; // System status register
        __IO csr_status_t STATUS_bf; // Bit access for STATUS register
    };
    union {
        __IO uint32_t CONTROL; // System control register
        __IO csr_control_t CONTROL_bf; // Bit access for CONTROL register
    };
    union {
        __IO uint32_t THRESHOLD; // Threshold configuration register
        __IO csr_threshold_t THRESHOLD_bf; // Bit access for THRESHOLD register
    };
    union {
        __IO uint32_t GAIN; // Gain control register
        __IO csr_gain_t GAIN_bf; // Bit access for GAIN register
    };
    union {
        __IO uint32_t INT_MASK; // Interrupt mask register
        __IO csr_int_mask_t INT_MASK_bf; // Bit access for INT_MASK register
    };
    union {
        __IO uint32_t INT_STATUS; // Interrupt status register
        __IO csr_int_status_t INT_STATUS_bf; // Bit access for INT_STATUS register
    };
    union {
        __I uint32_t VERSION; // Version and identification register
        __I csr_version_t VERSION_bf; // Bit access for VERSION register
    };
} csr_t;

#define CSR ((csr_t*)(CSR_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_H */